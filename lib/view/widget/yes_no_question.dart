
import 'package:flutter/material.dart';



class YesNoQuestionWidget extends StatefulWidget {
  final dynamic field;
  final ValueChanged<String?> onChanged;

  const YesNoQuestionWidget({
    Key? key,
    required this.field,
    required this.onChanged,
  }) : super(key: key);

  @override
  _YesNoQuestionWidgetState createState() => _YesNoQuestionWidgetState();
}

class _YesNoQuestionWidgetState extends State<YesNoQuestionWidget> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.field.properties?.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.field.properties?.label ?? 'Select Option';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Yes'),
          leading: Radio<String>(
            value: 'yes',
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
                widget.onChanged(value);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio<String>(
            value: 'no',
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
                widget.onChanged(value);
              });
            },
          ),
        ),
      ],
    );
  }
}
