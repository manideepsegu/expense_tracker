import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;

  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: transactions.map(
        (tx) {
          return TransactionItem(
            key: ValueKey(tx.id),
            transaction: tx,
            deleteTransaction: _deleteTransaction,
          );
        },
      ).toList(),
    );
  }
}
