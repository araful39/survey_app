import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surveyor_app/controller/survey_form_controller.dart';

import 'form_screen.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
  final SurveyFormController controller = Get.put(SurveyFormController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Survey Forms")),
      body: Obx(() {
        if (controller.formList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.formList.length,
          itemBuilder: (context, index) {
            final form = controller.formList[index];
            return ListTile(
              title: Text(form.formName ?? "Unnamed Form"),
              subtitle: Text("Form ID: ${form.id}"),
              onTap: () {

                Get.to(()=>FormScreen(form: form,));
                log("Tapped ${form.formName}");
              },
            );
          },
        );
      }),
    );
  }
}
