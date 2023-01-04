import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thiktok_clone/Views/widgets/network.dart';
import 'package:thiktok_clone/constants.dart';

import 'package:thiktok_clone/Models/user.dart' as model;

import 'package:image_picker/image_picker.dart';
import 'package:thiktok_clone/constants.dart';
import '../Views/screens/auth/login_screen.dart';
import '../Views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  User get user => _user.value!;

  late Rx<File?> _pickedImage;
  File? get profilePhoto => _pickedImage.value;
  @override
  void onReady() async {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    // bool v = await checkInternet();
    // print(v);
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      print("mobile");
      if (user == null) {
        Get.offAll(() => LoginScreen());
      } else {
        Get.offAll(() => const HomeScreen());
      }
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("wifi");

      if (user == null) {
        Get.offAll(() => LoginScreen());
      } else {
        Get.offAll(() => const HomeScreen());
      }

      // I am connected to a wifi network.
    } else {
      Center(child: CircularProgressIndicator());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _pickedImage = Rx<File?>(File(pickedImage.path));

      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        EasyLoading.show();
        // save out user to our ath and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();

        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();

      print(e);

      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    } catch (e) {
      EasyLoading.dismiss();

      print(e);
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        EasyLoading.show();

        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();

        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();

      Get.snackbar(
        'Error Loggin gin',
        e.message.toString(),
      );
    } catch (e) {
      EasyLoading.dismiss();

      Get.snackbar(
        'Error Loggin gin',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
