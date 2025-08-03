
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surveyor_app/controller/form_controller.dart';
import 'package:surveyor_app/model/survey_form_model.dart';
import 'package:surveyor_app/view/result_page.dart';
import 'package:surveyor_app/view/widget/image_upload.dart';


class FormScreen extends StatelessWidget {
  final formController = Get.put(FormController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SurveyFormModel form; // your existing model

  FormScreen({super.key, required this.form});

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

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
                  }).toList(),
                ],
              );
            }).toList(),

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




