import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'update_request.dart';
import 'ledger_session_container.dart';

class LedgerSession {
  final queryExecutor = const QueryExecutor();
  final Ledger ledger;
  final query = ValueNotifier<Query>(Query(accounts: ['Assets']));
  LedgerUpdateRequest lastUpdateRequest = LedgerUpdateRequestPlaceholder();

  LedgerSession({required this.ledger});

  static LedgerSession of(BuildContext context) {
    final container = context.findAncestorWidgetOfExactType<InheritedLedgerSessionContainer>();
    if (container == null) {
      throw 'Cannot find LedgerSessionContainer in widget tree, the ledger cannot be retrieved. This is generally the result of calling LedgerContainer.of(context) on a widget that is not a descendant of LedgerContainer';
    }
    return container.ledgerSession;
  }

  bool processUpdateRequest(LedgerUpdateRequest updateRequest) {
    if (lastUpdateRequest.staleFor(updateRequest)) {
      updateRequest.execute();
      lastUpdateRequest = updateRequest;
      return true;
    }
    return false;
  }
}