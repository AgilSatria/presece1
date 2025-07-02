import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD PEGAWAI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
              controller: controller.nipC,
              decoration: InputDecoration(
                  labelText: "NIP  ", border: OutlineInputBorder())),
          SizedBox(height: 20),
          TextField(
              controller: controller.nameC,
              decoration: InputDecoration(
                  labelText: "NAME  ", border: OutlineInputBorder())),
          SizedBox(height: 20),
          TextField(
              controller: controller.emailC,
              decoration: InputDecoration(
                  labelText: "EMAIL   ", border: OutlineInputBorder())),
          SizedBox(height: 40),
          Obx(() => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.addPegawai();
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "Add Pegawai" : "Loading...")))
        ],
      ),
    );
  }
}
