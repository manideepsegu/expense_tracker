import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key key,
    @required this.transaction,
    @required Function deleteTransaction,
  }) : _deleteTransaction = deleteTransaction, super(key: key);

  final Transaction transaction;
  final Function _deleteTransaction;

  @override
  Widget build(BuildContext context) {
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
              child: Text("\$${transaction.amount}"),
            ),
          ),
        ),
        title: Text(
          '${transaction.title}',
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: Theme.of(context).textTheme.subtitle,
        ),
        trailing: MediaQuery.of(context).orientation == Orientation.landscape
            ? FlatButton.icon(
                icon: Icon(Icons.delete),
                label: Text("Delete"),
                textColor: Theme.of(context).errorColor,
                onPressed: () {
                  _deleteTransaction(transaction.id);
                },
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  _deleteTransaction(transaction.id);
                },
              ),
      ),
    );
  }
}