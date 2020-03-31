import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;

  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return TransactionListItem(
          transaction: transactions[index],
          deleteTransaction: _deleteTransaction,
        );
      },
      itemCount: transactions.length,
    );
  }
}
