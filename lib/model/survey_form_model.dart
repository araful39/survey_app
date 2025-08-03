// class SurveyFormModel {
//   String? formName;
//   int? id;
//   List<Sections>? sections;
//
//   SurveyFormModel({this.formName, this.id, this.sections});
//
//   SurveyFormModel.fromJson(Map<String, dynamic> json) {
//     formName = json['formName'];
//     id = json['id'];
//     if (json['sections'] != null) {
//       sections = <Sections>[];
//       json['sections'].forEach((v) {
//         sections!.add(new Sections.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['formName'] = this.formName;
//     data['id'] = this.id;
//     if (this.sections != null) {
//       data['sections'] = this.sections!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Sections {
//   String? name;
//   String? key;
//   List<Fields>? fields;
//
//   Sections({this.name, this.key, this.fields});
//
//   Sections.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     key = json['key'];
//     if (json['fields'] != null) {
//       fields = <Fields>[];
//       json['fields'].forEach((v) {
//         fields!.add(new Fields.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['key'] = this.key;
//     if (this.fields != null) {
//       data['fields'] = this.fields!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Fields {
//   int? id;
//   String? key;
//   Properties? properties;
//
//   Fields({this.id, this.key, this.properties});
//
//   Fields.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     key = json['key'];
//     properties = json['properties'] != null
//         ? new Properties.fromJson(json['properties'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['key'] = this.key;
//     if (this.properties != null) {
//       data['properties'] = this.properties!.toJson();
//     }
//     return data;
//   }
// }
//
// class Properties {
//   String? type;
//   String? defaultValue;
//   String? hintText;
//   int? minLength;
//   int? maxLength;
//   String? label;
//   String? listItems;
//   bool? multiSelect;
//   bool? multiImage;
//
//   Properties(
//       {this.type,
//         this.defaultValue,
//         this.hintText,
//         this.minLength,
//         this.maxLength,
//         this.label,
//         this.listItems,
//         this.multiSelect,
//         this.multiImage});
//
//   Properties.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     defaultValue = json['defaultValue'];
//     hintText = json['hintText'];
//     minLength = json['minLength'];
//     maxLength = json['maxLength'];
//     label = json['label'];
//     listItems = json['listItems'];
//     multiSelect = json['multiSelect'];
//     multiImage = json['multiImage'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['defaultValue'] = this.defaultValue;
//     data['hintText'] = this.hintText;
//     data['minLength'] = this.minLength;
//     data['maxLength'] = this.maxLength;
//     data['label'] = this.label;
//     data['listItems'] = this.listItems;
//     data['multiSelect'] = this.multiSelect;
//     data['multiImage'] = this.multiImage;
//     return data;
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormScreen extends StatefulWidget {
  final SurveyFormModel form;

  const FormScreen({Key? key, required this.form}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  final ImagePicker _picker = ImagePicker();
  final Map<String, File?> _images = {};

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Form Values: $_formValues');
      print('Images: $_images');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.form.formName ?? 'Form'),
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: widget.form.sections?.length ?? 0,
          itemBuilder: (context, index) {
            final section = widget.form.sections![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.name ?? 'Section',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: section.fields?.length ?? 0,
                    itemBuilder: (context, sIndex) {
                      final field = section.fields![sIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildFieldWidget(field, sIndex),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget _buildFieldWidget(Fields field, int sIndex) {
    switch (field.id) {
      case 1: // Text Field
        return TextFormField(
          decoration: InputDecoration(
            labelText: field.properties?.label ?? 'Text Field',
            hintText: field.properties?.hintText ?? '',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter ${field.properties?.label ?? "text"}';
            }
            if (field.properties?.maxLength != null &&
                value.length > field.properties!.maxLength!) {
              return 'Max length is ${field.properties!.maxLength}';
            }
            if (field.properties?.minLength != null &&
                value.length < field.properties!.minLength!) {
              return 'Min length is ${field.properties!.minLength}';
            }
            return null;
          },
          onSaved: (value) {
            _formValues[field.key ?? 'text_$sIndex'] = value;
          },
        );

      case 2: // Dropdown or Checkbox
        List<dynamic> itemsList;
        try {
          itemsList = jsonDecode(field.properties?.listItems ?? '[]');
        } catch (e) {
          return const Text('Error: Invalid list items');
        }

        if (field.properties?.multiSelect == true) {
          return MyCheckboxListWidget(
            fields: field,
            onChanged: (values) {
              _formValues[field.key ?? 'checkbox_$sIndex'] = values;
            },
          );
        } else {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: field.properties?.label,
              hintText: field.properties?.hintText,
            ),
            items: itemsList.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem(
                value: item['value'].toString(),
                child: Text(item['name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _formValues[field.key ?? 'dropdown_$sIndex'] = value;
              });
            },
            onSaved: (value) {
              _formValues[field.key ?? 'dropdown_$sIndex'] = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an option';
              }
              return null;
            },
          );
        }

      case 3: // Radio Button (Yes/No)
        return YesNoQuestionWidget(
          field: field,
          onChanged: (value) {
            _formValues[field.key ?? 'radio_$sIndex'] = value;
          },
        );

      case 4: // Image Picker
        return ImagePickerWidget(
          field: field,
          onImageSelected: (file) {
            _images[field.key ?? 'image_$sIndex'] = file;
          },
        );

      default:
        return const Text('Unsupported field type');
    }
  }
}

class ImagePickerWidget extends StatefulWidget {
  final Fields field;
  final ValueChanged<File?> onImageSelected;

  const ImagePickerWidget(
      {Key? key, required this.field, required this.onImageSelected})
      : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.onImageSelected(_image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.properties?.label ?? 'Upload Image',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _image == null
            ? const Text('No image selected.')
            : Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Pick Image'),
        ),
      ],
    );
  }
}

class YesNoQuestionWidget extends StatefulWidget {
  final Fields field;
  final ValueChanged<String?> onChanged;

  const YesNoQuestionWidget(
      {Key? key, required this.field, required this.onChanged})
      : super(key: key);

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
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

class MyCheckboxListWidget extends StatefulWidget {
  final Fields fields;
  final ValueChanged<List<String>> onChanged;

  const MyCheckboxListWidget(
      {Key? key, required this.fields, required this.onChanged})
      : super(key: key);

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

class SurveyFormModel {
  String? formName;
  int? id;
  List<Sections>? sections;

  SurveyFormModel({this.formName, this.id, this.sections});

  SurveyFormModel.fromJson(Map<String, dynamic> json) {
    formName = json['formName'];
    id = json['id'];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['formName'] = formName;
    data['id'] = id;
    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sections {
  String? name;
  String? key;
  List<Fields>? fields;

  Sections({this.name, this.key, this.fields});

  Sections.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['key'] = key;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  int? id;
  String? key;
  Properties? properties;

  Fields({this.id, this.key, this.properties});

  Fields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['key'] = key;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Properties {
  String? type;
  String? defaultValue;
  String? hintText;
  int? minLength;
  int? maxLength;
  String? label;
  String? listItems;
  bool? multiSelect;
  bool? multiImage;

  Properties({
    this.type,
    this.defaultValue,
    this.hintText,
    this.minLength,
    this.maxLength,
    this.label,
    this.listItems,
    this.multiSelect,
    this.multiImage,
  });

  Properties.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    defaultValue = json['defaultValue'];
    hintText = json['hintText'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    label = json['label'];
    listItems = json['listItems'];
    multiSelect = json['multiSelect'];
    multiImage = json['multiImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['defaultValue'] = defaultValue;
    data['hintText'] = hintText;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    data['label'] = label;
    data['listItems'] = listItems;
    data['multiSelect'] = multiSelect;
    data['multiImage'] = multiImage;
    return data;
  }
}