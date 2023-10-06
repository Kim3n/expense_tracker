# Expense tracker

Basic Expense Tracker Application: This app serves as the initial assignment (Assignment 1) for the [IDATA2503 - Mobile Applications](https://www.ntnu.edu/studies/courses/IDATA2503) course at NTNU. Provided below is the essential documentation needed for this task.

## App architecture

Overview of the Application:
This app is centered around a single screen called "ExpenseScreen." This screen plays a crucial role in managing all the expense-related information and actions. It's essentially the go-to place for everything related to expenses; we like to call it the "Single Source of Truth."

On this screen, you'll find a list that you can scroll through, showing all your expenses. Additionally, there's a simple chart above the list that gives you a visual representation of how your expenses are distributed across different categories. This chart makes it easy to see where your money is going. So, in a nutshell, this screen helps you keep track of your expenses and see where your money is being spent.

## User stories

- As a user, I want the ability to efficiently eliminate any irrelevant expenses from the application, ensuring a clutter-free record.
- In my role as a user, I aim to effortlessly incorporate new expenses into the application, ensuring they are meticulously stored and organized.
- Additionally, I value the safeguard of my data. Therefore, I wish to have the ability to reverse a deletion operation, minimizing the risk of unintentional data loss.
- A graphical representation of various expense types, depicting their respective amounts, is a feature I seek to have access to. This enables me to gain insights into my spending patterns.
- I also desire the capability to modify existing expenses efficiently, providing a means to rectify any errors that may occur.

## Specifications

### Expense summary

User Interface Elements:

- Bar Chart: Presents a visual bar chart that illustrates the total expenses categorized under Food, Travel, Leisure, and Work.
- Expense List: Displays a comprehensive list of user-inputted expenses.
- Swipe-to-Delete: Empowers users to swipe left on an expense item to swiftly delete it.
- _Swipe-to-Edit: Additionally, includes a user-requested feature allowing right-swiping on an expense item to facilitate updates._ - **an extra feature**
- Undo Functionality: Following an expense deletion, a "Expense Deleted" notification materializes at the screen's bottom. Accompanied by an "Undo" button, this feature grants a brief 5-second window for reverting the deletion.
- Add Button: Situated in the upper-right corner, this button, adorned with a "+" icon, opens the initial expense creation screen.
- Undo Deletion: Provides a short-lived opportunity to reverse a deletion operation.

### Expense Entry Form

- Title Input Field: Permits users to input the expense's title.
- Amount Input Field: Comprises a currency symbol (Dolla) and a text box to enter the expense amount.
- Calendar Icon: Positioned adjacent to the amount input field, this feature facilitates the selection of a date.
- Category Dropdown: A dropdown menu featuring predefined options (Food, Travel, Leisure, Work), with "Food" pre-selected.
- Save Button: Commits the entered expense for record-keeping.
- Cancel Button: Aborts the expense entry process.

## File and folder structure

`main.dart` is the entry point of the application. it calls Flutter's `runApp` with styling, it also calls the `Expenses` Component

`expenses.dart` contains `Expenses`. 
It is responsible for expenses data, as well as displaying the chart (located in the chart folder, files are taken directly from Udemy course) and `ExpensesList`, which is located in `expenses_list.dart`.

`ExpensesList` is a list of dismissible items, each one is an `ExpenseItem`, defined in `expense_item.dart`.  

`expenses` is also responsible for showing a modal bottom sheet, which displays a widget defined in` new_expense.dart`.
In the models folder, there is `expense.dart` which contains the `Expense` class and `ExpenseBucket` class (needed for charts).

## Class diagram

![class diagram](./ClassDiagram.svg)

## Feedback to other student

# TODO Not done yet. 
