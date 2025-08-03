


import 'dart:convert';

import 'package:flutter/material.dart';

class MyCheckboxListWidget extends StatefulWidget {
  final dynamic fields;
  final ValueChanged<List<String>> onChanged;

  const MyCheckboxListWidget({
    Key? key,
    required this.fields,
    required this.onChanged,
  }) : super(key: key);

  @override
  _MyCheckboxListWidgetState createState() => _MyCheckboxListWidgetState();
}

class _MyCheckboxListWidgetState extends State<MyCheckboxListWidget> {
  List<String> selectedValues = [];

  @override
  Widget build(BuildContext context) {
    List<dynamic> itemsList;
    try {
      itemsList = jsonDecode(widget.fields.properties?.listItems ?? '[]');
    } catch (e) {
      return const Text('Error: Invalid list items');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fields.properties?.label ?? 'Select Options',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          itemCount: itemsList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, cIndex) {
            final item = itemsList[cIndex];
            final itemValue = item['value'].toString();
            final itemName = item['name'] ?? '';

            return CheckboxListTile(
              title: Text(itemName),
              value: selectedValues.contains(itemValue),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedValues.add(itemValue);
                  } else {
                    selectedValues.remove(itemValue);
                  }
                  widget.onChanged(selectedValues);
                });
              },
            );
          },
        ),
      ],
    );
  }
}
