import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

// Stateless widget because the data it is recieveing is from outside and stateless widgets can handle that
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  // Here we take the transactions list from main.dart
  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {

    // Container sets some spacing rules for the widgets or else they go outside the phone
    return Container(
      height: 300,

      // Displaying the image and informing the user that there is no tranactions added
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  "No Transactions added yet",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )

            // Displying the entire list of trnsactions
            // using ListView because it is scrollable and only loads that part of the list which is being watched currently, does not unnecessarily clusters the widgets like in column
          : ListView.builder(

              // ctx is the context taken care by flutter and index is the index of our list which we want to traverse
              itemBuilder: (ctx, index) {
                return Card(
                  // Creating individual List element to display
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          // truncating the value to 2 decimal places
                          '\$${transactions[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            // Default custom theme mentioned in main.dart
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            transactions[index].title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            // Date formats provided by intl library used externally mentioned in pubspec.yaml
                            DateFormat.yMMMd().format(transactions[index].date),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              // The stopping positon of the iteration
              itemCount: transactions.length,
            ),
    );
  }
}
