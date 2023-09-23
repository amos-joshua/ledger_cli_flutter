import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Ledger CLI Flutter Example',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ExampleApp()
    )
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ledger CLI Flutter Example')
      ),
      body: BalanceTable(
        balanceResult: BalanceResult(
            balances: [
              BalanceEntry(
                  account:'Assets:checking',
                  denominatedAmount: DenominatedAmount(5, 'USD')
              )
            ]
        ),
      ),
    );
  }
}