import 'package:flutter/widgets.dart';
import 'package:ledger_cli/ledger_cli.dart';

class QueryList extends ChangeNotifier {
  final _items = <Query>[];

  void add(Query query) {
    _items.add(query);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  Query queryAt(int index) => _items[index];
  int get length => _items.length;
}