import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presece1/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar(
                "Terjadi kesalahan", "password terlalu lemah 6 karakter");
          }
        } catch (e) {
          Get.snackbar(
              "Tidak bisa membuat Password baru", "Hubungi pihak admin");
        }
      } else {
        Get.snackbar("Terjadi Kesalahan ", "Harus Menggunakan Passbaru");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password baru Harus di isi");
    }
  }
}
