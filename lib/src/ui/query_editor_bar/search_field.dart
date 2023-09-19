import 'package:flutter/material.dart';
import 'text_field_delay.dart';

class SearchField extends StatelessWidget {
  final void Function(String) onChange;
  final String placeholder;
  late final searchDelay = TextFieldDelay<String>(onChange: onChange);
  final TextEditingController textEditingController;

  SearchField({required this.onChange, required this.textEditingController, required this.placeholder, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(15.0),
        color: Theme.of(context).primaryColorLight,
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: placeholder,
                  suffixIcon: InkWell(
                    child: const Icon(Icons.close),
                    onTap: () {
                      textEditingController.text = '';
                      onChange('');
                    },
                  )
              ),
              controller: textEditingController,
              onChanged: (newValue) { searchDelay.updateValue(newValue); print("DBG changed $newValue"); }
            )
        )
    );
  }

}