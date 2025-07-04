import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdatePasswordView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
              controller: controller.currC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password  ", border: OutlineInputBorder())),
          SizedBox(height: 20),
          Divider(thickness: 5), // ketebalan garis
          SizedBox(height: 20),
          TextField(
              controller: controller.newC,
              autocorrect: true,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "New Password   ", border: OutlineInputBorder())),
          SizedBox(height: 20),
          TextField(
              controller: controller.confirmC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Confirmation Password  ",
                  border: OutlineInputBorder())),
          SizedBox(height: 40),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updatePass();
                }
              },
              child: Text((controller.isLoading.isFalse)
                  ? "Change password"
                  : "Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
