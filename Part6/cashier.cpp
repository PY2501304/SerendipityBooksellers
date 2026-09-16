#include "cashier.h"
#include <iostream>
#include <iomanip>
#include <string>
using namespace std;

void cashier()
{
    string date, isbn, title, repeat_choice;
    int quantity;
    double price, subtotal, tax;
    bool repeat = true;
    bool repeat_check = true;
    
    while(repeat)
    {
    	cout << "Enter the Date (MM/DD/YY): ";
    	cin >> date;
    	
    	cout << "Enter the Quantity: ";
    	cin >> quantity;
    	
    	cout << "Enter the ISBN Number: ";
    	cin >> isbn;
    	
    	cout << "Enter the Title: ";
    	cin >> title;
    
    	cout << "Enter the Price: ";
    	cin >> price;
    
    	cout << "\nSerendipity Book Sellers\n";
    	cout << "\nDate: " << date;
    	
    	cout << "\n\nQty";
    	cout << "\tISBN";
    	cout << "\tTitle";
    	cout << "\t\tPrice";
    	cout << "\tTotal\n";
    	cout << "________________________________________________\n";
    	
    	subtotal = price * quantity;
    	tax = subtotal * 0.06;
    	
    	cout << quantity;
    	cout << "\t" << isbn;
    	cout << "\t" << title;
    	cout << "\t\t$" << price;
    	cout << "\t$" << subtotal;
    	
    	cout << "\n\n\tSubtotal" << "\t\t\t$" << subtotal;
    	cout << "\n\tTax" << "\t\t\t\t$" << tax;
    	cout << "\n\tTotal" << "\t\t\t\t$" << subtotal + tax;
    	
    	cout << "\n\nThank You for Shopping at Serendipity!\n";
    	
    	cout << "\nWould You Want Another Transcation?";
    	cout << "\nY/N: ";
    	cin >> repeat_choice;
    	
    	if(repeat_choice == "N" || repeat_choice == "n")
        {
            repeat = false;
            repeat_check = false;
        }
    	
    	while(repeat_check)
    	{
        	if(repeat_choice == "Y" || repeat_choice == "y")
        	{
        	    repeat = true;
        	    repeat_check = false;
        	}
        	else if(repeat_choice == "N" || repeat_choice == "n")
        	{
        	    repeat = false;
        	    repeat_check = false;
        	}
        	else
        	{
        	    cout << "\nWould You Want Another Transcation?";
        	    cout << "\nY/N: ";
        	    cin >> repeat_choice;
        	}
    	}
    }
}