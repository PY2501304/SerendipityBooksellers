#include "reports.h"
#include <iostream>
using namespace std;

void reports()
{
    int reports_choice;

    cout << "Serendipity Booksellers\n";
    cout << "\tReports\n";
    
    cout << "\n1. Inventory Listing\n";
    cout << "2. Inventory Wholesale Value\n";
    cout << "3. Inventory Retail Value\n";
    cout << "4. Listing by Quantity\n";
    cout << "5. Listing by Cost\n";
    cout << "6. Listing by Age\n";
    cout << "7. Return to Main Menu\n";
    
    cout << "\nEnter Your Choice: ";
    cin >> reports_choice;
    
    while(reports_choice < 1 || reports_choice > 7)
    {
        cout << "\nPlease enter a number in the range 1 - 7\n";
        cout << "\nEnter Your Choice: ";
        cin >> reports_choice;
    }
    
    switch(reports_choice)
    {
        case 1:
            repListing();
            break;
        case 2:
            repWholesale();
            break;
        case 3:
            repRetail();
            break;
        case 4:
            repQty();
            break;
        case 5:
            repCost();
            break;
        case 6:
            repAge();
            break;
        case 7:
            cout << "\nReturning to Main Menu\n";
            break;
    }

    cout << "You selected item " << reports_choice;
}

void repListing()
{
    cout << "You selected Inventory Listing\n";
}

void repWholesale()
{
    cout << "You selected Inventory Wholesale Value\n";
}

void repRetail()
{
    cout << "You selected Inventory Retail Value\n";
}

void repQty()
{
    cout << "You selected Listing by Quantity\n";
}

void repCost()
{
    cout << "You selected Listing by Cost\n";
}

void repAge()
{
    cout << "You selected Listing by Age\n";
}