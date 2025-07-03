import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presece1/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: const Center(
        child: Text(
          'HomeView is Aku coba aja',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (controller.isLoading.isFalse) {
            controller.isLoading.value = true;
            await FirebaseAuth.instance.signOut();
            controller.isLoading.value = false;
            Get.offAllNamed(Routes.LOGIN);
          }
        },
        backgroundColor: Colors.blue, // Warna latar belakang
        foregroundColor: Colors.white, // Warna ikon
        child: Icon(Icons.logout),
      ),
    );
  }
}
