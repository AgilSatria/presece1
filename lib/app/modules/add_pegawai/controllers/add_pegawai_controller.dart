import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;

  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    print("Add Pegawai");

    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back();
          Get.back();
          Get.snackbar("berhasil", "menambahkan pegawai");
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Gagal", " terlalu singkat.");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Maaf", "email sudah pernah digunakan");
        }
      } catch (e) {
        Get.snackbar('coba di cek kembali',
            'terjadi kesalahan name , email dan password belum di isi ');
      }
    } else {
      isLoading.value = false;

      Get.snackbar("Kesalahan", "Paassword Wajib diisi.");
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: "Validasi admin",
          content: Column(
            children: [
              Text("Masukan password untuk falidasi admin!"),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: Text("Cancel"),
            ),
            Obx(() => ElevatedButton(
                  onPressed: () async {
                    if (isLoadingAddPegawai.value == false) {
                      await prosesAddPegawai();
                    }
                    isLoading.value = false;
                  },
                  child: Text(isLoadingAddPegawai.isFalse
                      ? "Add PEGAWAI"
                      : "LOADIG..."),
                )),
          ]);
    } else {
      Get.snackbar(
          'terjadi kesalahan', 'NIP, name , email dan password belum di isi');
    }
  }
}
