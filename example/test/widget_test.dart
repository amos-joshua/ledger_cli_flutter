import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Balances table shows checking account', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home:ExampleApp()));

    // Verify that our counter starts at 0.
    expect(find.text('Assets:checking'), findsOneWidget);
    expect(find.text('5.00 USD'), findsOneWidget);
  });
}
