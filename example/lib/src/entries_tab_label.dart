import 'package:flutter/material.dart';

class EntriesTabLabel extends StatefulWidget {
  final int index;
  final String label;
  final void Function() onDelete;
  final TabController tabController;

  const EntriesTabLabel({required this.index, required this.label, required this.onDelete, required this.tabController, super.key});

  @override
  State createState() => _State();
}

class _State extends State<EntriesTabLabel> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(onTabChanged);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(onTabChanged);
    super.dispose();
  }

  void onTabChanged() {
    setState(() {
      // pass
    });
  }

  @override
  build(BuildContext context) {
    final isSelected = widget.tabController.index == widget.index;
    return Tab(
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Text(widget.label, style: isSelected ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) : const TextStyle(color: Colors.white54)),
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: widget.onDelete
        ),
      )
    );
  }
}