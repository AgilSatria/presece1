import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print(image!.name);
      print(image!.name.split(".").last);

      print(image!.path);
    } else {
      print(image);
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        await firestore.collection("pegawai").doc(uid).update(
          {
            "name": nameC.text,
          },
        );
        Get.snackbar("Berhasi", "Kamu telah update profil");
      } catch (e) {
        Get.snackbar("terjadikesalahan", "tidak bisa update profil saat ini");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
