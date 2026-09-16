#include "invmenu.h"
#include <iostream>
using namespace std;

void invMenu()
{
    int menu_choice;
    
	cout << "Serendipity Booksellers\n";
	cout << "  Inventory Database\n";
	
	cout << "\n1. Look Up a Book\n";
	cout << "2. Add a Book\n";
	cout << "3. Edit a Book's Record\n";
	cout << "4. Delete a Book\n";
	cout << "5. Return to the Main Menu\n";
	
    cout << "\nEnter Your Choice: ";
    cin >> menu_choice;

	while(menu_choice < 1 || menu_choice > 5)
    {
        cout << "\nPlease enter a number in the range 1 - 5\n";
        cout << "\nEnter Your Choice: ";
        cin >> menu_choice;
    }

    switch(menu_choice)
    {
        case 1:
            lookUpBook();
            break;
        case 2:
            addBook();
            break;
        case 3:
            editBook();
            break;
        case 4:
            deleteBook();
            break;
        case 5:
            cout << "\nReturning to Main Menu\n";
            break;
    }
}

void lookUpBook()
{
    cout << "You selected Look Up a Book\n";
}

void addBook()
{
    cout << "You selected Add a Book\n";
}

void editBook()
{
    cout << "You selected Edit a Book's Record\n";
}

void deleteBook()
{
    cout << "You selected Delete a Book\n";
}