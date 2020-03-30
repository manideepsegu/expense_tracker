import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;

  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
          elevation: 10,
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 5,
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FittedBox(
                  child: Text("\$${transactions[index].amount}"),
                ),
              ),
            ),
            title: Text(
              '${transactions[index].title}',
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text(
              DateFormat.yMMMd().format(transactions[index].date),
              style: Theme.of(context).textTheme.subtitle,
            ),
            trailing: MediaQuery.of(context).orientation == Orientation.landscape
                ? FlatButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                    textColor: Theme.of(context).errorColor,
                    onPressed: () {
                      _deleteTransaction(index);
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () {
                      _deleteTransaction(index);
                    },
                  ),
          ),
        );
      },
      itemCount: transactions.length,
    );
  }
}
