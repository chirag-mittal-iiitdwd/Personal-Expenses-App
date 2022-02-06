import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

// Stateless widget because the data it is recieveing is from outside and stateless widgets can handle that
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTnx;

  // Here we take the transactions list from main.dart
  TransactionList(this.transactions, this.deleteTnx);

  @override
  Widget build(BuildContext context) {
    // Container sets some spacing rules for the widgets or else they go outside the phone
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: [
                  Text(
                    "No Transactions added yet",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraint.maxHeight*0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )

        // Displying the entire list of trnsactions
        // using ListView because it is scrollable and only loads that part of the list which is being watched currently, does not unnecessarily clusters the widgets like in column
        : ListView.builder(
            // ctx is the context taken care by flutter and index is the index of our list which we want to traverse
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${transactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTnx(transactions[index].id),
                  ),
                ),
              );
            },
            // The stopping positon of the iteration
            itemCount: transactions.length,
          );
  }
}
