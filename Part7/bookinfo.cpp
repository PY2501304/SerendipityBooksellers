#include "bookinfo.h"
#include <iostream>
using namespace std;

void bookInfo(string isbn, string title, string author, string publisher, string dateAdded, int qtyOnHand, double wholesale, double retail)
{
    cout << "Serendipity Booksellers\n";
    cout << "    Book Information\n";
    
    cout << "\nISBN: " << isbn << "\n";
    cout << "Title: " << title << "\n";
    cout << "Author: " << author << "\n";
    cout << "Publisher: " << publisher << "\n";
    cout << "Data Added: " << dateAdded << "\n";
    cout << "Quantity-On-Hand: " << qtyOnHand << "\n";
    cout << "Wholesale Cost: " << wholesale << "\n";
    cout << "Retail Price: " << retail << "\n";
}