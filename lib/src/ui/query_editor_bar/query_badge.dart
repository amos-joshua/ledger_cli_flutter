import 'package:flutter/material.dart';

class QueryBadge extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onDelete;
  final Widget label;
  final Color? backgroundColor;

  const QueryBadge({required this.label, this.onTap, this.onDelete, this.backgroundColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: backgroundColor ?? Theme.of(context).primaryColorLight,
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: onTap ?? (){},
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