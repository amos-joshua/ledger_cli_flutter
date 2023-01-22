import 'package:flutter/material.dart';

import 'src/select_a_file_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ledger CLI Explorer',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: const SelectAFileScreen()
    );
  }
}
