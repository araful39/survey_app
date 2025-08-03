import 'dart:io';

import 'package:flutter/material.dart';
import 'package:surveyor_app/model/survey_form_model.dart';

class ImageUploadWidget extends StatelessWidget {
  final Fields field;
  final File? imageFile;
  final Function(File?) onImageSelected;
  final VoidCallback pickImage;

  const ImageUploadWidget({
    Key? key,
    required this.field,
    required this.imageFile,
    required this.onImageSelected,
    required this.pickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.properties?.label ?? 'Upload Image'),
        const SizedBox(height: 8),
        imageFile != null
            ? Image.file(imageFile!, width: 100, height: 100, fit: BoxFit.cover)
            : const Text("No image selected."),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: pickImage,
          child: const Text('Select Image'),
        ),
      ],
    );
  }
}