import 'package:flutter/material.dart';

class QueryBadge extends StatelessWidget {
  final void Function()? onDoubleTap;
  final void Function()? onDelete;
  final Widget label;

  const QueryBadge({required this.label, this.onDoubleTap, this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: Theme.of(context).primaryColorLight,
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onDoubleTap: onDoubleTap ?? (){},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: label,
                  )
              ),
              if (onDelete != null) InkWell(
                onTap: onDelete,
                child: const Icon(Icons.cancel_outlined),
              )
            ]
        ));
  }
}