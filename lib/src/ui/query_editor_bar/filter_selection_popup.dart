import 'package:flutter/material.dart';

class FilterSelectionPopup extends StatelessWidget {
  final bool allowGroupedBy;
  final void Function() onStartDate;
  final void Function() onEndDate;
  final void Function()? onGroupBy;
  const FilterSelectionPopup({required this.allowGroupedBy, required this.onStartDate, required this.onEndDate, this.onGroupBy, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.filter_list),
      itemBuilder: (buildContext) => [
        const PopupMenuItem(
          value: 'startDate',
          child: Text('From...')
        ),
        const PopupMenuItem(
          value: 'endDate',
          child: Text('Until...')
        ),
        if (allowGroupedBy) const PopupMenuItem(
          value: 'groupBy',
          child: Text('Group by...'),
        )
      ],
      onSelected: (String value) {
      if (value == 'startDate') {
        onStartDate();
      }
      else if (value == 'endDate') {
        onEndDate();
      }
      else if (value == 'groupBy') {
        final onGroupBy = this.onGroupBy;
        if (onGroupBy != null) {
          onGroupBy();
        }
      }
    });
  }
}