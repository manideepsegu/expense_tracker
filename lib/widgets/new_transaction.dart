import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function onPressed;

  NewTransaction(this.onPressed);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = _amountController.text.isEmpty
        ? 0
        : double.parse(_amountController.text);
    if (enteredTitle.isNotEmpty &&
        (enteredAmount >= 0) &&
        (_selectedDate != null)) {
      widget.onPressed(
        enteredTitle,
        enteredAmount,
        _selectedDate,
      );
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().subtract(Duration(days: 365)).year),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        _selectedDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: _titleController,
              onSubmitted: (_) => _submitData,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitData,
            ),
            Container(
              height: 80,
              child: Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      _selectedDate == null
                          ? 'Select Date!'
                          : 'Selected Date: ${DateFormat.yMd().format(_selectedDate)}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.calendar_today),
                    onPressed: _presentDatePicker,
                  )
                ],
              ),
            ),
            RaisedButton(
              child: Text("Add Transaction"),
              onPressed: _submitData,
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textSelectionColor,
            )
          ],
        ),
      ),
    );
  }
}
