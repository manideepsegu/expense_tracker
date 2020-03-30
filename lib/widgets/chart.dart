import 'package:expense_tracker/widgets/chart_bar.dart';
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../models/transaction.dart";

import "chart_bar.dart";

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        double sum = 0;
        for (var i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year) {
            sum += recentTransactions[i].amount;
          }
        }
        return {
          'day': DateFormat.E().format(weekDay).substring(0, 2),
          'amount': sum,
        };
      },
    ).reversed.toList();
  }

  double get _totalAmount {
    return recentTransactions.fold(0.0, (sum, tx) {
      return sum + tx.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SafeArea(
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    label: "${data['day']}",
                    amount: data['amount'],
                    percent: _totalAmount == 0
                        ? 0
                        : (data['amount'] as double) / _totalAmount,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
