import 'package:flutter/material.dart';

import './models/transaction.dart';
import './Widgets/new_transaction.dart';
import './Widgets/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // This title is used in backgrond mode, in task manager etc
      title: 'Personal Expenses',

      // Global themes including fonts and colors defined in main for easy access and convinience in other files
      theme: ThemeData(
        // Primary swatch gives us a bunch of shades of a color
        primarySwatch: Colors.purple,

        // This behaves like a secondary color. This is foreground color for widgets like knobs, text, overscroll edge effect, etc
        accentColor: Colors.amber,

        // Quicksand font family will be used generally if we dont add any other fonts in project
        fontFamily: 'Quicksand',

        // This will be used for texts in the project
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

        // Custom fonts for all the appbars throughout the entire app
        // With this we are using all default settings for AppBar except what we changed
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}


// We are using stateful widget because we are managing the state of the app inside main.dart file
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // The Transactions list which stores all the transactions
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: "Shoes",
    //   amount: 999,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 500,
    //   date: DateTime.now(),
    // )
  ];

  // Function which is triggered when a new transaction is added into the app
  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
    );

    // setState rebuilds the app with the changes which are enclosed in it
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  // this function is used for modalbottomsheet which comes from under the page when we click add more transactions
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        // Returns NewTransaction widget which is displayed over modalbottomsheet
        return NewTransaction(addNewTranaction: _addNewTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Expenses',
        ),

        // For adding a add button in the appbar right corner
        actions: [
          IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),

      // SingleChildScroolView is used to prevent oveflow from screen when keyboard comes up during adding new transaction
      body: SingleChildScrollView(

        // this contains the chart and the entire transaction list
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              child: Card(
                color: Colors.blue,
                child: Text("CHART"),
                elevation: 5,
                // Size of the card is defined by the size of child so if we want to change the size of card we must change the size of chlid, or the size is defined by the parent
              ),
            ),

            // Outputting the entire TransactionList
            TransactionList(_userTransactions),
          ],
        ),
      ),

      // Defining floating action button and it's functions
      // Defing its position
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
