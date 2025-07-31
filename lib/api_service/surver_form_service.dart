import 'dart:convert';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:surveyor_app/model/survey_form_model.dart';

class SurveyFormService {
  static Future<SurveyFormModel> fetchData(String fileName) async {
    final String jsonString = await rootBundle.loadString("assets/forms/$fileName");
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return SurveyFormModel.fromJson(jsonMap);
  }
}