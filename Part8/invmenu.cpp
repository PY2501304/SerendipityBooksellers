#include "invmenu.h"
#include "bookinfo.h"
#include <iostream>
using namespace std;

const int SIZE = 20;

extern string bookTitle[SIZE];
extern string isbn[SIZE];
extern string author[SIZE];
extern string publisher[SIZE];
extern string dateAdded[SIZE];
extern int qtyOnHand[SIZE];
extern double wholesale[SIZE];
extern double retail[SIZE];

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
    string lookUp;
    bool find = false;

    cout << "You selected Look Up a Book\n";

    cout << "\nEnter the Title of the Book: ";
    cin >> lookUp;
    cin.ignore();

    for(int i = 0; i < SIZE; i++)
    {
        if(bookTitle[i] == lookUp)
        {
            bookInfo(isbn[i], bookTitle[i], author[i], publisher[i], dateAdded[i], qtyOnHand[i], wholesale[i], retail[i]);
        }
    }

    if(!find)
    {
        cout << "\nBook Not Found\n";
    }
}

void addBook()
{
    cout << "\nYou selected Add a Book\n";

    for(int i = 0; i < SIZE; i++)
    {
        if(bookTitle[i] == "")
        {
            cout << "\nEnter the Title: ";
            cin >> bookTitle[i];
            cin.ignore();

            cout << "\nEnter the ISBN: ";
            cin >> isbn[i];
            cin.ignore();

            cout << "\nEnter the Author: ";
            getline(cin, author[i]);

            cout << "\nEnter the Publisher: ";
            getline(cin, publisher[i]);

            cout << "\nEnter the Data Added: ";
            getline(cin, dateAdded[i]);

            cout << "\nEnter the Quantity of the Book: ";
            cin >> qtyOnHand[i];
            cin.ignore();

            cout << "\nEnter the Wholesale Cost: ";
            cin >> wholesale[i];
            cin.ignore();

            cout << "\nEnter the Retail Price: ";
            cin >> retail[i];
            cin.ignore();

            break;
        }
    }
}

void editBook()
{
    string lookUp;
    bool find = false;
    int book;

    cout << "\nYou selected Edit a Book's Record\n";

    cout << "\nEnter the Title of the Book: ";
    cin >> lookUp;
    cin.ignore();

    for(int i = 0; i < SIZE; i++)
    {
        if(bookTitle[i] == lookUp)
        {
            int edit_choice;

            cout << "\n1. Edit ISBN\n";
            cout << "2. Edit Title\n";
            cout << "3. Edit Author\n";
            cout << "4. Edit Publisher\n";
            cout << "5. Edit Date Added\n";
            cout << "6. Edit Quantity on Hand\n";
            cout << "7. Edit Wholesale Cost\n";
            cout << "8. Edit Retail Price\n";

            cout << "\nEnter Your Choice: ";
            cin >> edit_choice;
            cin.ignore();

            while(edit_choice < 1 || edit_choice > 8)
            {
                cout << "\nPlease enter a number in the range 1 - 8\n";
                cout << "\nEnter Your Choice: ";
                cin >> edit_choice;
                cin.ignore();
            }

            switch(edit_choice)
            {
                case 1:
                    cout << "\nEnter the new ISBN: ";
                    cin >> isbn[book];
                    cin.ignore();
                    break;
                case 2:
                    cout << "\nEnter the new Title: ";
                    cin >> bookTitle[book];
                    cin.ignore();
                    break;
                case 3:
                    cout << "\nEnter the new Author: ";
                    getline(cin, author[book]);
                    break;
                case 4:
                    cout << "\nEnter the new Publisher: ";
                    getline(cin, publisher[book]);
                    break;
                case 5:
                    cout << "\nEnter the new Date Added: ";
                    getline(cin, dateAdded[book]);
                    break;
                case 6:
                    cout << "\nEnter the new Quantity on Hand: ";
                    cin >> qtyOnHand[book];
                    cin.ignore();
                    break;
                case 7:
                    cout << "\nEnter the new Wholesale Cost: ";
                    cin >> wholesale[book];
                    cin.ignore();
                    break;
                case 8:
                    cout << "\nEnter the new Retail Price: ";
                    cin >> retail[book];
                    cin.ignore();
                    break;
            }
        }
    }

    if(!find)
    {
        cout << "\nBook Not Found\n";
    }

    if(find)
    {
        int edit_choice;

        cout << "\n1. Edit ISBN\n";
        cout << "2. Edit Title\n";
        cout << "3. Edit Author\n";
        cout << "4. Edit Publisher\n";
        cout << "5. Edit Date Added\n";
        cout << "6. Edit Quantity on Hand\n";
        cout << "7. Edit Wholesale Cost\n";
        cout << "8. Edit Retail Price\n";

        cout << "\nEnter Your Choice: ";
        cin >> edit_choice;
        cin.ignore();

        while(edit_choice < 1 || edit_choice > 8)
        {
            cout << "\nPlease enter a number in the range 1 - 8\n";
            cout << "\nEnter Your Choice: ";
            cin >> edit_choice;
            cin.ignore();
        }

        switch(edit_choice)
        {
            case 1:
                cout << "\nEnter the new ISBN: ";
                cin >> isbn[book];
                cin.ignore();
                break;
            case 2:
                cout << "\nEnter the new Title: ";
                cin >> bookTitle[book];
                cin.ignore();
                break;
            case 3:
                cout << "\nEnter the new Author: ";
                getline(cin, author[book]);
                break;
            case 4:
                cout << "\nEnter the new Publisher: ";
                getline(cin, publisher[book]);
                break;
            case 5:
                cout << "\nEnter the new Date Added: ";
                getline(cin, dateAdded[book]);
                break;
            case 6:
                cout << "\nEnter the new Quantity on Hand: ";
                cin >> qtyOnHand[book];
                cin.ignore();
                break;
            case 7:
                cout << "\nEnter the new Wholesale Cost: ";
                cin >> wholesale[book];
                cin.ignore();
                break;
            case 8:
                cout << "\nEnter the new Retail Price: ";
                cin >> retail[book];
                cin.ignore();
                break;
        }
    }
}

void deleteBook()
{
    string lookUp;
    bool find = false;

    cout << "\nYou selected Delete a Book\n";

    cout << "\nEnter the Title of the Book: ";
    cin >> lookUp;
    cin.ignore();

    for(int i = 0; i < SIZE; i++)
    {
        if(bookTitle[i] == lookUp)
        {
            for(int i = 0; i < SIZE; i++)
            {
                if(bookTitle[i] == lookUp)
                {
                    bookTitle[i] = "";
                    isbn[i] = "";
                    author[i] = "";
                    publisher[i] = "";
                    dateAdded[i] = "";
                    qtyOnHand[i] = 0;
                    wholesale[i] = 0.0;
                    retail[i] = 0.0;
                    break;
                }
            }

            find = true;
            cout << "\nBook Deleted\n";
        }
    }

    if(!find)
    {
        cout << "\nBook Not Found\n";
    }
}