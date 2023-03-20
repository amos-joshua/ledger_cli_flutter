
import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import '../ledger_session/ledger_session.dart';
import 'query_editor_bar/filter_selection_popup.dart';
import 'query_editor_bar/search_field.dart';
import 'query_editor_bar/query_badge.dart';

class QueryEditorBar extends StatefulWidget {
  final bool searchFiltersAccounts;
  final bool allowGroupedBy;
  final bool allowStartDate;
  const QueryEditorBar({this.searchFiltersAccounts = false, this.allowGroupedBy = false, this.allowStartDate = true, super.key});

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
    ledgerSession.query.value = query.modify()..startDate = newDate;
  }

  DateTime? get endDate => ledgerSession.query.value.startDate;
  set endDate(DateTime? newDate) {
    ledgerSession.query.value = query.modify()..endDate = newDate;
  }

  List<String> get accounts => ledgerSession.query.value.accounts;
  set accounts(List<String> newAccounts) {
    ledgerSession.query.value = query.modify(accounts: newAccounts);
  }

  String get searchTerm => ledgerSession.query.value.searchTerm;
  set searchTerm(String newSearchTerm) {
    ledgerSession.query.value = query.modify(searchTerm: newSearchTerm);
  }

  PeriodLength? get groupBy => ledgerSession.query.value.groupBy;
  set groupBy(PeriodLength? newGroupBy) {
    ledgerSession.query.value = query.modify()..groupBy = newGroupBy;
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
        initialDate: endDate ?? DateTime.now(),
        firstDate: DateTime(1900),
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

  void selectGroupBy() {
    showDialog<PeriodLength>(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Group by..."),
        actions: [
          TextButton(
            child: const Text("Day"),
            onPressed: () {
              Navigator.of(context).pop(PeriodLength.day);
            },
          ),
          TextButton(
            child: const Text("Week"),
            onPressed: () {
              Navigator.of(context).pop(PeriodLength.week);
            },
          ),
          TextButton(
            child: const Text("Month"),
            onPressed: () {
              Navigator.of(context).pop(PeriodLength.month);
            },
          ),
          TextButton(
            child: const Text("Year"),
            onPressed: () {
              Navigator.of(context).pop(PeriodLength.year);
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          )
        ],
      );
    }).then((newGroupBy) {
      if (newGroupBy == null) return;
      groupBy = newGroupBy;
    });
  }

  void handleSearchUpdate(String newSearchTerm) {
    var trimmedSearchTerm = newSearchTerm.trim();
    if (widget.searchFiltersAccounts) {
      final lowercaseSearchTerm = trimmedSearchTerm.isEmpty ? 'assets' : trimmedSearchTerm.toLowerCase();
      accounts = ledgerSession.ledger.accountManager.accounts.keys.where((account) => account.toLowerCase().contains(lowercaseSearchTerm)).toList(growable: false);
    }
    else {
      searchTerm = trimmedSearchTerm;
    }
  }

  Widget startDateBadge(DateTime startDate) => QueryBadge(
    label: Text('from ${ledgerDateFormatter.format(startDate)}'),
    onDoubleTap: selectStartDate,
    onDelete: clearStartDate
  );

  Widget endDateBadge(DateTime endDate) => QueryBadge(
      label: Text('until ${ledgerDateFormatter.format(endDate)}'),
      onDoubleTap: selectEndDate,
      onDelete: clearEndDate
  );

  Widget groupByBadge(PeriodLength groupBy) => QueryBadge(
      label: Text('Group by ${groupBy.name}'),
      onDoubleTap: selectGroupBy,
  );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ValueListenableBuilder(
        valueListenable: ledgerSession.query,
        builder: (context, query, tree) {
          final queryStartDate = query.startDate;
          final queryEndDate = query.endDate;
          final queryGroupBy = query.groupBy;
          return SizedBox(
              width: mediaQuery.size.width,
              height: 60,
              child: Row(
                  children: [
                  Expanded(
                        child: SearchField(
                          textEditingController: searchController,
                          onChange: handleSearchUpdate,
                          placeholder: widget.searchFiltersAccounts ? 'Assets' : 'Filter...'
                        )
                    ),
                    if (queryStartDate != null) startDateBadge(queryStartDate),
                    if (queryEndDate != null) endDateBadge(queryEndDate),
                    if (queryGroupBy != null) groupByBadge(queryGroupBy),
                    FilterSelectionPopup(
                      onStartDate: widget.allowStartDate ? selectStartDate : null,
                      onEndDate: selectEndDate,
                      onGroupBy: widget.allowGroupedBy ? selectGroupBy : null,
                    )
                  ]
              ));
        }
    );

  }

}