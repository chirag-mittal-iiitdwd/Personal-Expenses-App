import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../Widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrasactions;
  Chart(this.recentTrasactions);

  // The list will have 7 maps which will contain our current day of the week and the total amount spent on that week
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTrasactions.length; i++) {
        // We are using this because the weekday is of DateTime object type and it has time also so we cant just directly compare the date from list of transactions to weekday because time can never be equal instead we check if that current date, year and day are equal
        if (recentTrasactions[i].date.day == weekDay.day &&
            recentTrasactions[i].date.month == weekDay.month &&
            recentTrasactions[i].date.year == weekDay.year) {
          totalSum += recentTrasactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              // fit property dosn't allow the bar to grow
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
