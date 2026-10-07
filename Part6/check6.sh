#!/bin/bash
# Part 6 self-check. Run from your Part6 folder:  bash check6.sh
D="${1:-Part6}"
if [ -d "$D" ]; then cd "$D"; elif ls *.cpp >/dev/null 2>&1; then :; else echo "Can't find your Part 6 files. Use cd to go into your Part 6 folder, then run this again."; exit 1; fi

T=$(mktemp -d); BIN=$T/prog; trap 'rm -rf "$T"' EXIT
PASS=0; TOTAL=0
good() { PASS=$((PASS+1)); TOTAL=$((TOTAL+1)); echo "  PASS  $1"; }
bad()  { TOTAL=$((TOTAL+1)); echo "  FAIL  $1"; [ -n "$2" ] && echo "        Hint: $2"; }
finish() { echo; echo "$PASS of $TOTAL checks passed."; echo "These checks are a guide, not your grade. Passing all of them does not guarantee full credit."; exit 0; }
find1() { find . -name "$1" -not -path './.git/*' | head -1; }
runf()  { printf "$1" | timeout 5 "$BIN" 2>&1 | head -c 200000 > "$T/out"; CODE=${PIPESTATUS[1]}; OUT=$(cat "$T/out"); }
cnt()   { grep -cF "$1" <<<"$OUT"; }
cntn()  { grep -cE "(^|[^0-9.])$1([^0-9]|\$)" <<<"$OUT"; }
newtxt() { grep -vxFf "$1" <<<"$OUT"; }

CPPS=$(find . -name '*.cpp' -not -path './.git/*' | sort)
HDRS=$(find . -name '*.h' -not -path './.git/*' | sort)

echo "Part 6 self-check"
echo; echo "Files and structure"
n=$(grep -lE 'int[[:space:]]+main[[:space:]]*\(' $CPPS 2>/dev/null | wc -l); mm=$(find1 mainmenu.cpp)
if [ "$n" = 1 ] && [ -n "$mm" ] && grep -qE 'int[[:space:]]+main[[:space:]]*\(' "$mm"; then good "Only mainmenu.cpp has main()"; else bad "Only mainmenu.cpp should have main()" "Rename main in cashier.cpp, invmenu.cpp, bookinfo.cpp, and reports.cpp."; fi
miss=""
for fn in cashier invMenu bookInfo reports; do grep -qE "^[[:space:]]*void[[:space:]]+$fn[[:space:]]*\(" $CPPS 2>/dev/null || miss="$miss $fn"; done
if [ -z "$miss" ]; then good "cashier, invMenu, bookInfo, reports are defined with the right names"; else bad "These functions are missing or misnamed:$miss" "Names must match the PDF exactly, including capitalization."; fi
while read a b; do
  h=$(find1 "$a.h"); c=$(find1 "$a.cpp")
  if [ -n "$h" ] && [ -n "$c" ] && grep -qE "\b$b *\(" "$h" && grep -q "#include \"$a.h\"" "$c"; then good "$a.h has the $b prototype and $a.cpp includes it"; else bad "$a.h / $a.cpp: header missing, no $b prototype, or $a.cpp doesn't include it"; fi
done <<< "cashier cashier
invmenu invMenu
bookinfo bookInfo
reports reports"
miss=""; for fn in lookUpBook addBook editBook deleteBook; do grep -q "$fn" "$(find1 invmenu.h)" 2>/dev/null || miss="$miss $fn"; done
if [ -z "$miss" ]; then good "invmenu.h has the four inventory stub prototypes"; else bad "invmenu.h is missing prototypes for:$miss"; fi
miss=""; for fn in repListing repWholesale repRetail repQty repCost repAge; do grep -q "$fn" "$(find1 reports.h)" 2>/dev/null || miss="$miss $fn"; done
if [ -z "$miss" ]; then good "reports.h has the six report stub prototypes"; else bad "reports.h is missing prototypes for:$miss"; fi

echo; echo "Build"
INC=$(for h in $HDRS; do dirname "$h"; done | sort -u | sed 's/^/-I/' | tr '\n' ' ')
if g++ -Wall -Wextra $INC -o "$BIN" $CPPS 2> "$T/build.log"; then good "Program builds ($(grep -c 'warning' "$T/build.log") warnings)"; else bad "Program does not build" "Fix the first error below, then run this again."; head -15 "$T/build.log"; finish; fi

echo; echo "Main menu"
runf '4\n'
if [ "$CODE" = 0 ]; then good "Choosing 4 ends the program"; else bad "Choosing 4 should end the program normally" "Exit code was $CODE."; fi
runf '2\n5\n4\n'; echo "$OUT" > "$T/base_inv"; INV_C=$CODE; INV_M=$(grep -ci 'cashier' <<<"$OUT")
if grep -qi 'look up' <<<"$OUT"; then good "Choice 2 opens the Inventory Database menu"; else bad "Choice 2 should open the Inventory Database menu" "Is case 2 in main's switch calling invMenu()?"; fi
runf '3\n7\n4\n'; echo "$OUT" > "$T/base_rep"; REP_C=$CODE; REP_M=$(grep -ci 'cashier' <<<"$OUT")
if grep -qi 'wholesale' <<<"$OUT"; then good "Choice 3 opens the Reports menu"; else bad "Choice 3 should open the Reports menu" "Is case 3 in main's switch calling reports()?"; fi

echo; echo "Inventory menu"
miss=""
for p in "1 look" "2 add" "3 edit" "4 delete"; do
  set -- $p; runf "2\n$1\n5\n4\n"
  grep -qiw "$2" <<<"$(newtxt "$T/base_inv")" || miss="$miss $1"
done
if [ -z "$miss" ]; then good "Choices 1-4 each show a message naming their item"; else bad "No message naming the item for choice(s):$miss" "Each stub should display a message that identifies its menu item, and the switch should call the right stub."; fi
runf '2\n1\n2\n5\n4\n'; M=$(grep -ci 'cashier' <<<"$OUT")
if [ "$M" = 2 ]; then good "Menu stays open until 5 is chosen"; elif [ "$M" = 3 ]; then bad "Menu returns to the main menu after one choice" "Put a loop around the menu so it repeats until the user picks 5 (Part 5)."; else bad "Couldn't tell whether the menu repeats" "Test it by hand: pick 1, then 2, then 5."; fi
if [ "$INV_C" = 0 ] && [ "$INV_M" = 2 ]; then good "Choosing 5 returns to the main menu"; else bad "Choosing 5 should return to the main menu" "The menu should end when the user picks 5 (Return to the Main Menu), not another number."; fi
runf '2\n9\n5\n4\n'
if [ "$CODE" = 0 ] && [ -n "$(newtxt "$T/base_inv")" ]; then good "Entering 9 shows an error message"; else bad "Entering 9 should show an error message and ask again" "Check the range validation (1-5)."; fi

echo; echo "Reports menu"
miss=""
for p in "1 listing" "2 wholesale" "3 retail" "4 quantity" "5 cost" "6 age"; do
  set -- $p; runf "3\n$1\n7\n4\n"
  grep -qiw "$2" <<<"$(newtxt "$T/base_rep")" || miss="$miss $1"
done
if [ -z "$miss" ]; then good "Choices 1-6 each show a message naming their report"; else bad "No message naming the report for choice(s):$miss" "Each stub should display a message that identifies its report, and the switch should call the right stub."; fi
runf '3\n1\n3\n7\n4\n'; M=$(grep -ci 'cashier' <<<"$OUT")
if [ "$M" = 2 ]; then good "Menu stays open until 7 is chosen"; elif [ "$M" = 3 ]; then bad "Menu returns to the main menu after one choice" "Put a loop around the menu so it repeats until the user picks 7 (Part 5)."; else bad "Couldn't tell whether the menu repeats" "Test it by hand: pick 1, then 3, then 7."; fi
if [ "$REP_C" = 0 ] && [ "$REP_M" = 2 ]; then good "Choosing 7 returns to the main menu"; else bad "Choosing 7 should return to the main menu" "The menu should end when the user picks 7 (Return to Main Menu), not another number. Check every case in your switch for a missing break."; fi
runf '3\n8\n7\n4\n'
if [ "$CODE" = 0 ] && [ -n "$(newtxt "$T/base_rep")" ]; then good "Entering 8 shows an error message"; else bad "Entering 8 should show an error message and ask again" "Check the range validation (1-7)."; fi

echo; echo "Cashier (from the main menu)"
runf '1\n05/24/12\n2\n0-333-90123-8\nHistory of Scotland\n19.95\nn\n4\n'
if [ "$(cnt 'History of Scotland')" -ge 1 ]; then good "A title with spaces works"; else bad "A title with spaces ('History of Scotland') breaks the cashier" "cin >> reads only one word. Use getline for the title, and call cin.ignore() first to clear the leftover newline."; fi
runf '1\n05/24/12\n2\n0-333-90123-8\nScotland\n19.95\nn\n4\n'
if [ "$(cntn '39\.90')" -ge 1 ] && [ "$(cntn '2\.39')" -ge 1 ] && [ "$(cntn '42\.29')" -ge 1 ]; then good "Subtotal, tax, and total print as 39.90, 2.39, and 42.29"; else bad "Money doesn't print as 39.90, 2.39, and 42.29" "Use fixed and setprecision(2) (and setw(6)). This check doesn't look at column alignment."; fi
S2=0
for yes in y 1; do
  for no in n 0 2; do
    runf "1\n05/24/12\n2\n0-333-90123-8\nScotland\n19.95\n$yes\n05/25/12\n1\n1-111-11111-1\nTwo\n10.00\n$no\n4\n"
    if [ "$CODE" = 0 ] && [ "$(cnt 'Scotland')" -ge 1 ] && [ "$(cnt 'Two')" -ge 1 ]; then S2=1; break 2; fi
  done
done
if [ "$S2" = 1 ]; then good "Another transaction runs a second sale, and answering no ends it"; else bad "A second sale didn't work" "Test by hand: finish a sale, answer the another-transaction prompt with yes (y or 1, whatever your prompt asks for), enter another sale, then answer no (n or 0)."; fi
echo; echo "(Cashier checks assume the prompts ask for date, quantity, ISBN, title, price in that order, and that y or 1 means another sale and n, 0, or 2 means stop. If yours differ, test by hand.)"
finish