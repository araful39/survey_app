
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surveyor_app/controller/form_controller.dart';
import 'package:surveyor_app/model/survey_form_model.dart';
import 'package:surveyor_app/view/result_page.dart';
import 'package:surveyor_app/view/widget/image_upload.dart';
import 'package:surveyor_app/view/widget/my_checbox.dart';
import 'package:surveyor_app/view/widget/yes_no_question.dart';


class FormScreen extends StatelessWidget {
  final formController = Get.put(FormController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SurveyFormModel form;

  FormScreen({super.key, required this.form});

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

//asss
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonData = jsonEncode(formController.formValues);
      await prefs.setString('latest_form_data', jsonData);


      Get.to(() => ResultPage(formData: formController.formValues));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(form.formName ?? 'Form'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...form.sections!.map((section) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.name ?? 'Section',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  ...section.fields!.map((field) {
                    if (field.id == 1) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
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
                            formController.setValue(field.key ?? 'text_${field.id}', value);
                          },
                          decoration: InputDecoration(
                            hintText: field.properties?.hintText ?? "",
                            labelText: field.properties?.label ?? '',
                          ),
                        ),
                      );
                    } else if (field.id == 2) {
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
                            formController.setValue(field.key ?? 'checkbox_${field.id}', values);
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
                            formController.setValue(field.key ?? 'dropdown_${field.id}', value);
                          },
                          onSaved: (value) {
                            formController.setValue(field.key ?? 'dropdown_${field.id}', value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        );
                      }
                    } else if (field.id == 3) {
                      return YesNoQuestionWidget(
                        field: field,
                        onChanged: (value) {
                          formController.setValue(field.key ?? 'radio_${field.id}', value);
                        },
                      );
                    } else if (field.id == 4) {
                      return Obx(() {
                        final imageRx = formController.getImageRx(field.key ?? 'image_${field.id}');
                        return ImageUploadWidget(
                          field: field,
                          imageFile: imageRx.value,
                          onImageSelected: (file) {
                            formController.setValue(field.key ?? 'image_${field.id}', file?.path ?? '');
                          },
                          pickImage: () => formController.pickImage(field.key ?? 'image_${field.id}'),
                        );
                      });
                    }
                    return const SizedBox();
                  }),
                ],
              );
            }),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}


///setstate code

// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class FormScreen extends StatefulWidget {
//   final SurveyFormModel form;
//
//   const FormScreen({Key? key, required this.form}) : super(key: key);
//
//   @override
//   _FormScreenState createState() => _FormScreenState();
// }
//
// class _FormScreenState extends State<FormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, dynamic> _formValues = {};
//   final ImagePicker _picker = ImagePicker();
//   final Map<String, File?> _images = {};
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       print('Form Values: $_formValues');
//       print('Images: $_images');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Form submitted successfully!')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.form.formName ?? 'Form'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView.builder(
//           padding: const EdgeInsets.all(16.0),
//           itemCount: widget.form.sections?.length ?? 0,
//           itemBuilder: (context, index) {
//             final section = widget.form.sections![index];
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     section.name ?? 'Section',
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: section.fields?.length ?? 0,
//                     itemBuilder: (context, sIndex) {
//                       final field = section.fields![sIndex];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: _buildFieldWidget(field, sIndex),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _submitForm,
//         child: const Icon(Icons.send),
//       ),
//     );
//   }
//
//   Widget _buildFieldWidget(Fields field, int sIndex) {
//     switch (field.id) {
//       case 1: // Text Field
//         return TextFormField(
//           decoration: InputDecoration(
//             labelText: field.properties?.label ?? 'Text Field',
//             hintText: field.properties?.hintText ?? '',
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Enter ${field.properties?.label ?? "text"}';
//             }
//             if (field.properties?.maxLength != null &&
//                 value.length > field.properties!.maxLength!) {
//               return 'Max length is ${field.properties!.maxLength}';
//             }
//             if (field.properties?.minLength != null &&
//                 value.length < field.properties!.minLength!) {
//               return 'Min length is ${field.properties!.minLength}';
//             }
//             return null;
//           },
//           onSaved: (value) {
//             _formValues[field.key ?? 'text_$sIndex'] = value;
//           },
//         );
//
//       case 2: // Dropdown or Checkbox
//         List<dynamic> itemsList;
//         try {
//           itemsList = jsonDecode(field.properties?.listItems ?? '[]');
//         } catch (e) {
//           return const Text('Error: Invalid list items');
//         }
//
//         if (field.properties?.multiSelect == true) {
//           return MyCheckboxListWidget(
//             fields: field,
//             onChanged: (values) {
//               _formValues[field.key ?? 'checkbox_$sIndex'] = values;
//             },
//           );
//         } else {
//           return DropdownButtonFormField<String>(
//             decoration: InputDecoration(
//               labelText: field.properties?.label,
//               hintText: field.properties?.hintText,
//             ),
//             items: itemsList.map<DropdownMenuItem<String>>((item) {
//               return DropdownMenuItem(
//                 value: item['value'].toString(),
//                 child: Text(item['name']),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _formValues[field.key ?? 'dropdown_$sIndex'] = value;
//               });
//             },
//             onSaved: (value) {
//               _formValues[field.key ?? 'dropdown_$sIndex'] = value;
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select an option';
//               }
//               return null;
//             },
//           );
//         }
//
//       case 3: // Radio Button (Yes/No)
//         return YesNoQuestionWidget(
//           field: field,
//           onChanged: (value) {
//             _formValues[field.key ?? 'radio_$sIndex'] = value;
//           },
//         );
//
//       case 4: // Image Picker
//         return ImagePickerWidget(
//           field: field,
//           onImageSelected: (file) {
//             _images[field.key ?? 'image_$sIndex'] = file;
//           },
//         );
//
//       default:
//         return const Text('Unsupported field type');
//     }
//   }
// }
//
// class ImagePickerWidget extends StatefulWidget {
//   final Fields field;
//   final ValueChanged<File?> onImageSelected;
//
//   const ImagePickerWidget(
//       {Key? key, required this.field, required this.onImageSelected})
//       : super(key: key);
//
//   @override
//   _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
// }
//
// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   File? _image;
//
//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         widget.onImageSelected(_image);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.field.properties?.label ?? 'Upload Image',
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         _image == null
//             ? const Text('No image selected.')
//             : Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
//         ElevatedButton(
//           onPressed: _pickImage,
//           child: const Text('Pick Image'),
//         ),
//       ],
//     );
//   }
// }
//
// class YesNoQuestionWidget extends StatefulWidget {
//   final Fields field;
//   final ValueChanged<String?> onChanged;
//
//   const YesNoQuestionWidget(
//       {Key? key, required this.field, required this.onChanged})
//       : super(key: key);
//
//   @override
//   _YesNoQuestionWidgetState createState() => _YesNoQuestionWidgetState();
// }
//
// class _YesNoQuestionWidgetState extends State<YesNoQuestionWidget> {
//   String? selectedValue;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedValue = widget.field.properties?.defaultValue;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final label = widget.field.properties?.label ?? 'Select Option';
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ListTile(
//           title: const Text('Yes'),
//           leading: Radio<String>(
//             value: 'yes',
//             groupValue: selectedValue,
//             onChanged: (value) {
//               setState(() {
//                 selectedValue = value;
//                 widget.onChanged(value);
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('No'),
//           leading: Radio<String>(
//             value: 'no',
//             groupValue: selectedValue,
//             onChanged: (value) {
//               setState(() {
//                 selectedValue = value;
//                 widget.onChanged(value);
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class MyCheckboxListWidget extends StatefulWidget {
//   final Fields fields;
//   final ValueChanged<List<String>> onChanged;
//
//   const MyCheckboxListWidget(
//       {Key? key, required this.fields, required this.onChanged})
//       : super(key: key);
//
//   @override
//   _MyCheckboxListWidgetState createState() => _MyCheckboxListWidgetState();
// }
//
// class _MyCheckboxListWidgetState extends State<MyCheckboxListWidget> {
//   List<String> selectedValues = [];
//
//   @override
//   Widget build(BuildContext context) {
//     List<dynamic> itemsList;
//     try {
//       itemsList = jsonDecode(widget.fields.properties?.listItems ?? '[]');
//     } catch (e) {
//       return const Text('Error: Invalid list items');
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.fields.properties?.label ?? 'Select Options',
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         ListView.builder(
//           itemCount: itemsList.length,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (context, cIndex) {
//             final item = itemsList[cIndex];
//             final itemValue = item['value'].toString();
//             final itemName = item['name'] ?? '';
//
//             return CheckboxListTile(
//               title: Text(itemName),
//               value: selectedValues.contains(itemValue),
//               onChanged: (bool? value) {
//                 setState(() {
//                   if (value == true) {
//                     selectedValues.add(itemValue);
//                   } else {
//                     selectedValues.remove(itemValue);
//                   }
//                   widget.onChanged(selectedValues);
//                 });
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }


