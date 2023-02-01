
import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import '../ledger_session/ledger_session.dart';
import 'account_selector_button.dart';

class QueryEditorBar extends StatefulWidget {
  const QueryEditorBar({super.key});

  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<QueryEditorBar> {
  static const ledgerDateFormatter = LedgerDateFormatter();
  late final LedgerSession ledgerSession;

  final searchController = TextEditingController();

  Query get query => ledgerSession.query.value;

  DateTime? get startDate => ledgerSession.query.value.startDate;
  set startDate(DateTime? newDate) {
    ledgerSession.query.value = query.modify(startDate: newDate);
  }

  DateTime? get endDate => ledgerSession.query.value.startDate;
  set endDate(DateTime? newDate) {
    ledgerSession.query.value = query.modify(endDate: newDate);
  }

  List<String> get accounts => ledgerSession.query.value.accounts;
  set accounts(List<String> newAccounts) {
    ledgerSession.query.value = query.modify(accounts: newAccounts);
  }

  String get searchTerm => ledgerSession.query.value.searchTerm;
  set searchTerm(String newSearchTerm) {
    ledgerSession.query.value = query.modify(searchTerm: newSearchTerm);
  }

  @override
  void initState() {
    super.initState();
    ledgerSession = LedgerSession.of(context);
    searchController.text = query.searchTerm;
  }

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
    return ValueListenableBuilder(
        valueListenable: ledgerSession.query,
        builder: (context, query, tree) {
          return SizedBox(
              width: mediaQuery.size.width,
              height: 60,
              child: Row(
                  children: [
                    AccountSelectorButton(ledgerSession: ledgerSession),
                    Expanded(
                        child: Card(
                            color: Colors.white,
                            child: TextField(
                              controller: searchController,
                              onChanged: (newValue) => searchTerm = newValue.trim(),
                            )
                        )
                    ),
                    ElevatedButton(onPressed: selectStartDate, onLongPress: clearStartDate, child: Text('Start date: ${dateOrNone(query.startDate)}')),
                    ElevatedButton(onPressed: selectEndDate, onLongPress: clearEndDate, child: Text('End date: ${dateOrNone(query.endDate)}')),
                  ]
              ));
        }
    );

  }

}