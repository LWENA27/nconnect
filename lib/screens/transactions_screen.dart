import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction_adapter.dart';
import '../storage/hive_boxes.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    var box = await Hive.openBox<Transaction>(HiveBoxes.transactionBox);
    setState(() {
      transactions = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions/Escrow'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 1,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.separated(
          padding: EdgeInsets.all(12),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.monetization_on, color: Colors.blue),
                title: Text('Transaction: ${tx.transactionId}', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Status: ${tx.status}'),
                trailing: Text('Amount: ${tx.amount.toStringAsFixed(2)}', style: TextStyle(color: Colors.blue)),
              ),
            );
          },
        ),
      ),
    );
  }
}
