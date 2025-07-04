import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presece1/app/routes/app_pages.dart';

class UpdatePasswordController extends GetxController {
  // Reactive loading state
  RxBool isLoading = false.obs;

  // Text editing controllers
  final TextEditingController currC = TextEditingController();
  final TextEditingController newC = TextEditingController();
  final TextEditingController confirmC = TextEditingController();

  // Firebase auth instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Method to update password
  Future<void> updatePass() async {
    final currentPassword = currC.text.trim();
    final newPassword = newC.text.trim();
    final confirmPassword = confirmC.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Kesalahan", "Semua kolom harus diisi.");
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
          "Password Tidak Cocok", "Password baru dan konfirmasi harus sama.");
      return;
    }

    isLoading.value = true;

    try {
      final emailUser = auth.currentUser?.email;
      if (emailUser == null) {
        Get.snackbar("Error", "Tidak dapat menemukan email pengguna.");
        return;
      }

      // Re-authenticate user
      await auth.signInWithEmailAndPassword(
        email: emailUser,
        password: currentPassword,
      );

      // Update password
      await auth.currentUser?.updatePassword(newPassword);

      // Optional: Logout and login again
      await auth.signOut();
      await auth.signInWithEmailAndPassword(
        email: emailUser,
        password: newPassword,
      );

      // ✅ Tampilkan snackbar & alihkan ke halaman HOME
      Get.snackbar("Berhasil", "Password berhasil diperbarui.");
      Get.offAllNamed(Routes.HOME); // navigasi ke halaman HOME
      // Kembali ke halaman sebelumnya
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        Get.snackbar("Terjadi Kesalahan", e.message ?? e.code);
      } else {
        Get.snackbar(
            "Password Salah", "Password lama yang Anda masukkan salah.");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui password.");
    } finally {
      isLoading.value = false;
    }
  }
}
