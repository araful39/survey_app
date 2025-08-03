import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FormController extends GetxController {
  final Map<String, dynamic> formValues = {};
  final Map<String, Rx<File?>> images = {};
  final ImagePicker _picker = ImagePicker();

  void setValue(String key, dynamic value) {
    formValues[key] = value;
    update();
  }

  Rx<File?> getImageRx(String key) {
    if (!images.containsKey(key)) {
      images[key] = Rx<File?>(null);
    }
    return images[key]!;
  }

  Future<void> pickImage(String key) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (!images.containsKey(key)) {
        images[key] = file.obs;
      } else {
        images[key]!.value = file;
      }
      formValues[key] = file.path;
      update();
    }
  }
}