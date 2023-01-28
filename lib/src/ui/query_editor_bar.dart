
import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';

class QueryEditorBar extends StatefulWidget {
  const QueryEditorBar({super.key});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<QueryEditorBar> {
  static const ledgerDateFormatter = LedgerDateFormatter();

  final searchController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  String dateOrNone(DateTime? date) => date == null ? 'None' : ledgerDateFormatter.format(date);

  void selectStartDate() {
    showDatePicker(
        context: context,
        initialDate:startDate ?? DateTime.now(),
        firstDate:DateTime(1900),
        lastDate: DateTime(2100)).then((newDate) {
          if (newDate == null) return;
          setState(() {
            startDate = newDate;
          });
    });
  }

  void clearStartDate() {
    setState(() {
      startDate = null;
    });
  }

  void selectEndDate() {
    showDatePicker(
        context: context,
        initialDate:endDate ?? DateTime.now(),
        firstDate:DateTime(1900),
        lastDate: DateTime(2100)).then((newDate) {
      if (newDate == null) return;
      setState(() {
        endDate = newDate;
      });
    });
  }

  void clearEndDate() {
    setState(() {
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
        width: mediaQuery.size.width,
        height: 60,
        child: Row(
      children: [
        Expanded(child:Card(color: Colors.white, child: TextField(controller: searchController))),
        ElevatedButton(onPressed: selectStartDate, onLongPress: clearStartDate, child: Text('Start date: ${dateOrNone(startDate)}')),
        ElevatedButton(onPressed: selectEndDate, onLongPress: clearEndDate, child: Text('End date: ${dateOrNone(endDate)}')),
      ]
    ));
  }

}