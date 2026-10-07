#!/bin/bash
# Part 7 self-check. Run from your Part7 folder:  bash check7.sh
V=${V:-0}
D="${1:-Part7}"
if [ -d "$D" ]; then cd "$D"; elif ls *.cpp >/dev/null 2>&1; then :; else echo "Can't find your Part 7 files. Use cd to go into your Part 7 folder, then run this again."; exit 1; fi

T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
PASS=0; TOTAL=0
good() { PASS=$((PASS+1)); TOTAL=$((TOTAL+1)); echo "  PASS  $1"; }
bad()  { TOTAL=$((TOTAL+1)); echo "  FAIL  $1"; [ -n "$2" ] && echo "        Hint: $2"; }
finish() { echo; echo "$PASS of $TOTAL checks passed."; echo "These checks are a guide, not your grade. Passing all of them does not guarantee full credit."; exit 0; }
find1() { find . -name "$1" -not -path './.git/*' | head -1; }

CPPS=$(find . -name '*.cpp' -not -path './.git/*' | sort)
HDRS=$(find . -name '*.h' -not -path './.git/*' | sort)
INC=$(for h in $HDRS; do dirname "$h"; done | sort -u | sed 's/^/-I/' | tr '\n' ' ')

echo "Part 7 self-check"
if [ "$V" = 1 ]; then
  echo "######## $(basename "$(dirname "$PWD")") / $(basename "$PWD") ########"
  echo; echo "== FILES =="; find . -type f -not -path './.git/*' | sort
  echo; echo "== bookinfo.h =="; for h in $(find . -iname 'bookinfo.h'); do echo "--- $h"; grep -v '^[[:space:]]*$' "$h"; done
  echo; echo "== EVERY LINE MENTIONING bookinfo (ANY CAPITALIZATION) =="; grep -inH 'bookinfo' $CPPS $HDRS
  echo; echo "== GLOBAL ARRAY DECLARATIONS FOUND IN SOURCE =="
  grep -nE '^(const )?(std::)?(string|int|double|float|long|char)[[:space:]]+(bookTitle|isbn|author|publisher|dateAdded|qtyOnHand|wholesale|retail)[[:space:]]*\[' $CPPS $HDRS
fi

echo; echo "Build"
OBJS=""; BUILD_OK=1; i=0
for f in $CPPS; do
  i=$((i+1)); o="$T/o$i.o"
  g++ -Wall -Wextra $INC -c "$f" -o "$o" 2>>"$T/build.log" || BUILD_OK=0
  OBJS="$OBJS $o"
done
if [ "$BUILD_OK" = 1 ]; then g++ $OBJS -o "$T/prog" 2>>"$T/build.log" || BUILD_OK=0; fi
if [ "$BUILD_OK" = 1 ]; then good "Program builds ($(grep -c 'warning' "$T/build.log") warnings)"; else
  bad "Program does not build" "Fix the first error below, then run this again."
  grep -E 'error|undefined|multiple definition' "$T/build.log" | head -10
  tip() { grep -qE "$1" "$T/build.log" && echo "        Tip: $2"; }
  tip "'(setprecision|setw|setfill)' (was not declared|is not a member)" "setprecision and setw need #include <iomanip> at the top of the file named in the error."
  tip "'string' (was not declared|does not name a type|has not been declared|is not a member of)" "Add #include <string> and using namespace std; to the file named in the error. bookinfo.h needs them too."
  tip "'(cout|cin|endl)' (was not declared|is not a member)" "Add #include <iostream> and using namespace std; to the file named in the error."
  tip "too (many|few) arguments to function|no matching function for call to .bookInfo|undefined reference to .bookInfo" "The prototype in bookinfo.h and the definition in bookinfo.cpp must both have the eight parameters."
  tip "multiple definition of" "A global array is defined more than once. Do not define the arrays in a header that several files include. Define each one in a single .cpp file."
  finish
fi

echo; echo "Global arrays"
printf '%s\n' '#include <string>' '#include <iostream>' 'int main() { std::cout << sizeof(std::string) << " " << sizeof(int) << " " << sizeof(double) << std::endl; }' > "$T/sz.cpp"
g++ -o "$T/sz" "$T/sz.cpp" && read SS SI SD < <("$T/sz")
SYMS=$(nm -S --defined-only -C $OBJS 2>/dev/null | sed 's/\[abi:cxx11\]//')
missing=""; wrong=""
for p in bookTitle:S isbn:S author:S publisher:S dateAdded:S qtyOnHand:I wholesale:D retail:D; do
  n=${p%%:*}; k=${p##*:}
  case $k in S) e=$((20*SS));; I) e=$((20*SI));; D) e=$((20*SD));; esac
  line=$(awk -v n="$n" '$NF==n' <<<"$SYMS" | head -1)
  if [ -z "$line" ]; then missing="$missing $n"; [ "$V" = 1 ] && echo "  $n: not found"; continue; fi
  ty=$(awk '{print $(NF-1)}' <<<"$line"); sz=$(awk '{print $(NF-2)}' <<<"$line")
  case $ty in B|D) ;; *) missing="$missing $n"; [ "$V" = 1 ] && echo "  $n: found but not global (type $ty)"; continue;; esac
  dec=$((16#$sz))
  [ "$V" = 1 ] && echo "  $n: $dec bytes (expected $e for 20 elements)"
  [ "$dec" = "$e" ] || wrong="$wrong $n"
done
if [ -z "$missing" ]; then good "All eight arrays exist at global scope with the right names"; else bad "Missing, misnamed, or not global:$missing" "Names must match the PDF exactly, including capitalization. Declare each array outside every function, and do not make it static."; fi
if [ -z "$wrong" ]; then good "The arrays have the right types and 20 elements"; else bad "Wrong type or size for:$wrong" "bookTitle, isbn, author, publisher, and dateAdded are string arrays. qtyOnHand is an int array. wholesale and retail are double arrays. All hold 20 elements."; fi

echo; echo "bookInfo"
src=$(find1 bookinfo.cpp); hdr=$(find1 bookinfo.h)
srcany=$(find . -iname 'bookinfo.cpp' -not -path './.git/*' | head -1); hdrany=$(find . -iname 'bookinfo.h' -not -path './.git/*' | head -1)
if [ -z "$src" ] && [ -n "$srcany" ]; then echo "        Tip: Your file is named $(basename "$srcany"). The PDF's name is bookinfo.cpp, all lowercase."; fi
if [ -z "$hdr" ] && [ -n "$hdrany" ]; then echo "        Tip: Your header is named $(basename "$hdrany"). The PDF's name is bookinfo.h, all lowercase."; fi
if [ -n "$hdrany" ] && grep -qiE 'bookinfo[[:space:]]*\([[:space:]]*(void)?[[:space:]]*\)[[:space:]]*;' "$hdrany"; then echo "        Tip: $(basename "$hdrany") still has the old prototype with no parameters. Replace it with the eight-parameter version."; fi
printf '%s\n' '#include <string>' 'void bookInfo(std::string, std::string, std::string, std::string, std::string, int, double, double) {}' > "$T/ref.cpp"
g++ -c "$T/ref.cpp" -o "$T/ref.o"
EXP=$(nm --defined-only "$T/ref.o" | awk '{print $NF}' | grep bookInfo | head -1)
GOT=$(nm --defined-only $OBJS 2>/dev/null | awk '{print $NF}' | grep bookInfo)
ALT=$(nm --defined-only -C $OBJS 2>/dev/null | sed 's/^[0-9a-f]* [A-Za-z] //' | grep -i '^bookinfo(' | grep -v '^bookInfo(' | sed 's/(.*//' | head -1)
[ "$V" = 1 ] && echo "bookInfo symbols found: $(nm --defined-only -C $OBJS 2>/dev/null | grep bookInfo | sed 's/^[0-9a-f]* [A-Za-z] //' | tr '\n' ';')"
if grep -qxF "$EXP" <<<"$GOT"; then good "bookInfo takes eight parameters with the right types and order"; elif [ -z "$GOT" ] && [ -n "$ALT" ]; then bad "bookInfo is spelled differently" "Your function is called $ALT. The PDF's name is bookInfo, with a capital I. Rename it in bookinfo.cpp, in bookinfo.h, and wherever you call it."; elif [ -z "$GOT" ]; then bad "bookInfo is not defined" "Define void bookInfo in bookinfo.cpp."; else bad "bookInfo does not take the right parameters" "The parameters are: string isbn, string title, string author, string publisher, string date, int qty, double wholesale, double retail. Update bookinfo.cpp and the prototype in bookinfo.h."; fi
names=""
HINTN="Check the definition in bookinfo.cpp."; [ -z "$src" ] && src="$srcany"; [ -z "$src" ] && HINTN="No bookinfo.cpp file was found."
if [ -n "$src" ]; then names=$(perl -0777 -ne 'if (/bookInfo\s*\(([^)]*)\)\s*\{/si) { my $s = $1; $s =~ s/\s+/ /g; my @p = split /,/, $s; print join(" ", map { my $w = (split " ", $_)[-1]; $w =~ s/^[&*]+//; $w } @p) }' "$src"); fi
[ "$V" = 1 ] && echo "parameter names found: $names"
if [ "$names" = "isbn title author publisher date qty wholesale retail" ]; then good "The parameter names match the PDF"; else bad "The parameter names should be: isbn, title, author, publisher, date, qty, wholesale, retail" "Found: ${names:-none}. $HINTN"; fi

printf '%s\n' '#include <string>' '#include <iostream>' 'using namespace std;' '#include "bookinfo.h"' 'int main(int argc, char** argv)' '{' '  if (argc > 1 && argv[1][0] == 50)' '    bookInfo("0-111-22222-3", "Second Title", "Second Author", "Second Press", "01-15-2020", 7, 7, 12.5);' '  else' '    bookInfo("1-999111-22-1", "Robert the Bruce, King of Scotland", "Haynes, Timothy", "Historical Publishers, Inc.", "04-02-2012", 20, 15.50, 19.95);' '  return 0;' '}' > "$T/drv.cpp"
RUN=0; WHY=""
if [ -z "$hdr" ] && [ -n "$hdrany" ]; then WHY="the header is named $(basename "$hdrany"), but the PDF's name is bookinfo.h"
elif ! g++ $INC -c "$T/drv.cpp" -o "$T/drv.o" 2>"$T/drv.log"; then
  if [ -n "$ALT" ]; then WHY="your function is called $ALT, but the PDF's name is bookInfo"; else WHY="bookinfo.h does not declare bookInfo with the eight parameters"; fi
else
  MAINO=$(for o in $OBJS; do nm --defined-only "$o" 2>/dev/null | grep -qE ' T main$' && echo "$o"; done | head -1)
  LOBJS=$(for o in $OBJS; do [ "$o" != "$MAINO" ] && echo "$o"; done)
  if g++ "$T/drv.o" $LOBJS -o "$T/drv" 2>"$T/link.log"; then RUN=1
  elif grep -q bookInfo "$T/link.log"; then WHY="the prototype in bookinfo.h does not match the definition in bookinfo.cpp"
  elif g++ "$T/drv.o" $LOBJS -Wl,--unresolved-symbols=ignore-all -o "$T/drv" 2>>"$T/link.log"; then RUN=1
  else WHY="the test program could not be linked"; fi
fi
if [ "$RUN" = 1 ]; then
  timeout 5 "$T/drv" > "$T/o1.txt" 2>&1; timeout 5 "$T/drv" 2 > "$T/o2.txt" 2>&1
  O1=$(head -c 20000 "$T/o1.txt"); O2=$(head -c 20000 "$T/o2.txt")
  if [ "$V" = 1 ]; then echo; echo "-- bookInfo output, PDF example data --"; echo "$O1"; echo "-- bookInfo output, second data set --"; echo "$O2"; fi
  heading=1; grep -qF 'Serendipity Booksellers' <<<"$O1" || heading=0; grep -qF 'Book Information' <<<"$O1" || heading=0
  missl=""
  for l in "ISBN:" "Title:" "Author:" "Publisher:" "Date Added:" "Quantity-On-Hand:" "Wholesale Cost:" "Retail Price:"; do grep -qE "^[[:space:]]*$l" <<<"$O1" || missl="$missl [$l]"; done
  if [ "$heading" = 1 ] && [ -z "$missl" ]; then good "The heading and all eight labels are on the screen"; else bad "Heading or labels missing${missl:+:$missl}" "Use the Book Information screen from the PDF: Serendipity Booksellers, Book Information, then ISBN, Title, Author, Publisher, Date Added, Quantity-On-Hand, Wholesale Cost, Retail Price."; fi
  badv=""
  linefor() { grep -E "^[[:space:]]*$1" <<<"$2" | head -1; }
  for pair in "ISBN:|1-999111-22-1" "Title:|Robert the Bruce, King of Scotland" "Author:|Haynes, Timothy" "Publisher:|Historical Publishers, Inc." "Date Added:|04-02-2012"; do
    l=${pair%%|*}; v=${pair#*|}; grep -qF "$v" <<<"$(linefor "$l" "$O1")" || badv="$badv [$l]"
  done
  grep -qE '(^|[^0-9.])20([^0-9]|$)' <<<"$(linefor 'Quantity-On-Hand:' "$O1")" || badv="$badv [Quantity-On-Hand:]"
  grep -qE '(^|[^0-9.])15\.50?([^0-9]|$)' <<<"$(linefor 'Wholesale Cost:' "$O1")" || badv="$badv [Wholesale Cost:]"
  grep -qE '(^|[^0-9.])19\.95([^0-9]|$)' <<<"$(linefor 'Retail Price:' "$O1")" || badv="$badv [Retail Price:]"
  if [ -z "$badv" ]; then good "Each value shows up next to its own label"; else bad "Wrong or missing value for:$badv" "Check that each parameter is printed on its own line, and that you did not mix up two parameters."; fi
  mon=1
  grep -qE '(^|[^0-9.])15\.50([^0-9]|$)' <<<"$(linefor 'Wholesale Cost:' "$O1")" || mon=0
  grep -qE '(^|[^0-9.])19\.95([^0-9]|$)' <<<"$(linefor 'Retail Price:' "$O1")" || mon=0
  grep -qE '(^|[^0-9.])7\.00([^0-9]|$)' <<<"$(linefor 'Wholesale Cost:' "$O2")" || mon=0
  grep -qE '(^|[^0-9.])12\.50([^0-9]|$)' <<<"$(linefor 'Retail Price:' "$O2")" || mon=0
  if [ "$mon" = 1 ]; then good "Wholesale and retail print with two decimals (15.50, 7.00)"; else bad "Wholesale and retail do not print with two decimals" "Use fixed and setprecision(2) inside bookInfo, so 15.5 prints as 15.50. Do not count on another function to set it."; fi
else
  bad "Could not run bookInfo: $WHY" "Fix this first. The three checks below need bookInfo to run."
  bad "The heading and labels could not be checked"
  bad "The values could not be checked"
  bad "The money format could not be checked"
fi
finish