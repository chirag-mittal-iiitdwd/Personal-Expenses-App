import 'package:flutter/material.dart';

import './transaction_list.dart';
import './new_transaction.dart';
import '../models/transaction.dart';

class UserTrasactions extends StatefulWidget {
  @override
  _UserTrasactionsState createState() => _UserTrasactionsState();
}

class _UserTrasactionsState extends State<UserTrasactions> {
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

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransaction(
          addNewTranaction: _addNewTransaction,
        ),
        TransactionList(
          _userTransactions,
        ),
      ],
    );
  }
}
