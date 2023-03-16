
abstract class LedgerUpdateRequest {
  final void Function() execute;
  LedgerUpdateRequest({required this.execute});

  bool staleFor(LedgerUpdateRequest nextUpdateRequest);
}

class LedgerUpdateRequestPlaceholder extends LedgerUpdateRequest {
  LedgerUpdateRequestPlaceholder(): super(execute: (){});

  @override
  bool staleFor(LedgerUpdateRequest nextUpdateRequest) => true;
}

class LedgerUpdateRequestFromPath extends LedgerUpdateRequest {
  final String ledgerPath;
  LedgerUpdateRequestFromPath(this.ledgerPath, {required super.execute});

  @override
  bool staleFor(LedgerUpdateRequest nextUpdateRequest) {
    if (nextUpdateRequest is! LedgerUpdateRequestFromPath) return true;
    return nextUpdateRequest.ledgerPath != ledgerPath;
  }
}