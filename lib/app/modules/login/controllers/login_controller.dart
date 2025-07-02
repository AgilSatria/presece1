import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presece1/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        print(userCredential);

        if (userCredential.user != null) {
          isLoading.value = false;

          if (userCredential.user!.emailVerified == true) {
            if (passC.text.isEmpty || passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            isLoading.value = false;

            Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText:
                  "Kamu belum verifikasi akun ini. Lakukan verifikasi di email kamu.",
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back(); // bisa buat tutup dialog
                  }, // bisa buat tutup dialog
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back(); // bisa buat tutup dialog
                      Get.snackbar("Berhasil",
                          "Kami telah berhasil mengirim email verifikasi ke akun kamu.");
                      isLoading.value = false;
                    } catch (e) {
                      Get.snackbar("Terjadi Kesalahan",
                          "Tidak dapat mengirim email verifikasi. Hubungi admin.");
                      isLoading.value = false;
                    }
                  },
                  child: Text("KIRIM ULANG"),
                ),
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        print("Firebase Error Code: ${e.code}");
        isLoading.value = false;

        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi kesalahan", "Email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Password Bermasalah", "Password tidak sesuai");
        } else if (e.code == 'invalid-email') {
          Get.snackbar("Format Salah", "Format email tidak valid");
        } else {
          Get.snackbar("Login Gagal", "User atau password salah");
        }
        ;
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "tidak dapat login");
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Email dan Password Wajib diisi");
    }
  }
}
