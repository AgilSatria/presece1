import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // yang akan di update
    controller.nipC.text = user["nip"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    //ini

    print(user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
              readOnly: true,
              controller: controller.nipC,
              decoration: InputDecoration(
                  labelText: "NIP  ", border: OutlineInputBorder())),
          SizedBox(height: 20),
          TextField(
              readOnly: true,
              controller: controller.emailC,
              decoration: InputDecoration(
                  labelText: "EMAIL   ", border: OutlineInputBorder())),
          SizedBox(height: 20),
          TextField(
              autocorrect: false,
              controller: controller.nameC,
              decoration: InputDecoration(
                  labelText: "NAME  ", border: OutlineInputBorder())),
          SizedBox(height: 20),
          Text(
            "photo profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipOval(
                        child: Container(
                      height: 100,
                      width: 100,
                      child: Image.file(
                        File(c.image!.path),
                        fit: BoxFit.cover,
                      ),
                    ));
                  } else {
                    if (user["profile"] != null) {
                      return ClipOval(
                          child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          user["profile"],
                          fit: BoxFit.cover,
                        ),
                      ));
                    } else {
                      return Text("no image chosen");
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: Text("choose"),
              ),
            ],
          ),
          SizedBox(height: 40),
          Obx(() => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.updateProfile(user["uid"]);
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "Update Profile"
                  : "Loading...")))
        ],
      ),
    );
  }
}
