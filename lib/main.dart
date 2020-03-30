import 'dart:io';

import 'package:flutter/material.dart';
// To disable landscape mode
// import 'package:flutter/services.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/chart.dart';
import 'models/transaction.dart';

void main() {
  runApp(MyApp());
  // To disable landscape mode
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Expense Tracker',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final title;

  MyHomePage({@required this.title});

  List<Transaction> get initialTx {
    List<Transaction> txList = [];
    for (int i = 0; i < 10; i++) {
      final tx = Transaction(
        title: "Text$i",
        amount: (20 + 10 * i).toDouble(),
        date: DateTime.now().subtract(Duration(days: i)),
        id: DateTime.now().subtract(Duration(days: i)).toString(),
      );
      txList.add(tx);
    }
    return txList;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState(initialTx);
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions;
  bool _showChart = true;

  _MyHomePageState(this._userTransactions);

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      id: date.toString(),
      title: title,
      amount: amount,
      date: date,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "Delete Transaction?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() => _userTransactions.removeAt(index));
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;
    if (!isLandscape) {
      _showChart = true;
    }
    final appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      floatingActionButton: isLandscape || Platform.isIOS
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _startAddNewTransaction(context);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _userTransactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: constraints.maxHeight * 0.15,
                  ),
                  Center(
                    child: Container(
                      height: constraints.maxHeight * 0.05,
                      child: FittedBox(
                        child: Text(
                          "No transactios yet!",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.1,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.4,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.3,
                  ),
                ],
              );
            })
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (isLandscape)
                    Container(
                      height: (mediaQuery.size.height -
                              mediaQuery.padding.top -
                              appBar.preferredSize.height) *
                          0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColorLight,
                            value: _showChart,
                            onChanged: (val) {
                              setState(() {
                                _showChart = val;
                              });
                            },
                          ),
                          Text("Chart or Transactions"),
                        ],
                      ),
                    ),
                  if (_showChart || !isLandscape)
                    Container(
                      height: (mediaQuery.size.height -
                              mediaQuery.padding.top -
                              appBar.preferredSize.height) *
                          ((isLandscape) ? 0.8 : 0.25),
                      child: Chart(_recentTransactions),
                    ),
                  if (!_showChart || !isLandscape)
                    Container(
                      height: (mediaQuery.size.height -
                              mediaQuery.padding.top -
                              appBar.preferredSize.height) *
                          (isLandscape ? 0.8 : 0.75),
                      child: TransactionList(
                          _userTransactions, _deleteTransaction),
                    ),
                ],
              ),
            ),
    );
  }
}
