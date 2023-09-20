import 'package:flutter/widgets.dart';
import 'package:ledger_cli/ledger_cli.dart';

class QueryList extends ChangeNotifier {
  final _items = <ValueNotifier<Query>>[];

  void add(Query query) {
    _items.add(ValueNotifier(query));
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  ValueNotifier<Query> queryAt(int index) => _items[index];
  int get length => _items.length;

  Map<int, ValueNotifier<Query>> asMap() => _items.asMap();

  Iterable<T> map<T>(T Function(ValueNotifier<Query>) func) => _items.map((query) => func(query));
}