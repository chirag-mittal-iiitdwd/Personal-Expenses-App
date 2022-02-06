import 'package:flutter/material.dart';

import './models/transaction.dart';
import './Widgets/new_transaction.dart';
import './Widgets/transaction_list.dart';
import './Widgets/chart.dart';

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
        errorColor: Colors.red,

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
              button: TextStyle(
                color: Colors.white,
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
    Transaction(
      id: 't1',
      title: "Shoes",
      amount: 999,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 500,
      date: DateTime.now(),
    )
  ];

  // Getters are dynamically generated values
  // This function only passes the trsactions which are in 7 days
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  // Function which is triggered when a new transaction is added into the app
  void _addNewTransaction(String txTitle, double txAmount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: date,
    );

    // setState rebuilds the app with the changes which are enclosed in it
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
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

  bool _showChart = false;
  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation==Orientation.landscape;

    final appBar = AppBar(
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
    );

    final txList=Container(
                    height: (MediaQuery.of(context).size.height * 0.7) -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top,
                    child:
                        TransactionList(_userTransactions, _deleteTransaction),
                  );

    return Scaffold(
      appBar: appBar,

      // SingleChildScroolView is used to prevent oveflow from screen when keyboard comes up during adding new transaction
      body: SingleChildScrollView(
        // this contains the chart and the entire transaction list
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(isLandscape)Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                )
              ],
            ),

            if(!isLandscape)Container(
                    height: ((MediaQuery.of(context).size.height) -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.3,
                    child: Chart(_recentTransactions),
                  ),
            if(!isLandscape)txList,
            if(isLandscape)_showChart
                ? Container(
                    height: ((MediaQuery.of(context).size.height) -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_recentTransactions),
                  )
                :txList
                // Outputting the entire TransactionList
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
