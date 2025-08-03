import 'dart:developer';

import 'package:get/get.dart';
import 'package:surveyor_app/api_service/surver_form_service.dart';
import 'package:surveyor_app/model/survey_form_model.dart';

class SurveyFormController extends GetxController {
  List<String> formFiles = ['form1.json', 'form2.json', 'form3.json'];
  RxList<SurveyFormModel> formList = <SurveyFormModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllForms();
  }
  void loadAllForms() async {
    try {
      for (String file in formFiles) {
        final form = await SurveyFormService.fetchData(file);
        formList.add(form);
      }
    } catch (e) {
      log("Error loading forms: $e");
    }
  }
}
