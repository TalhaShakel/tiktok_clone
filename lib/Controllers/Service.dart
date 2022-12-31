import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

var fAuth = FirebaseAuth.instance;
var fStorage = FirebaseStorage.instance;
firestore_set(collection, doc, set) async {
  try {
    EasyLoading.show();
    doc != null
        ? await FirebaseFirestore.instance
            .collection(collection.toString())
            .doc(doc.toString())
            .set(set, SetOptions(merge: true))
        : await FirebaseFirestore.instance
            .collection(collection.toString())
            .add(set);
    EasyLoading.dismiss();
  } on FirebaseException catch (e) {
    EasyLoading.dismiss();
    Get.snackbar("${e.message}", "");
  }
}

firestore_Sec_set(collection, secCollection, doc, doc2, data,
    {bool update = false}) async {
  if (update == true) {
    print("using Update function");
    var dat = FirebaseFirestore.instance
        .collection("$collection")
        .doc("$doc")
        .collection("$secCollection")
        .doc("$doc2")
        .update(data);
    return dat;
  } else
    doc2 != null
        ? await FirebaseFirestore.instance
            .collection(collection.toString())
            .doc(doc.toString())
            .collection(secCollection)
            .doc(doc2)
            .set(data)
        : await FirebaseFirestore.instance
            .collection(collection.toString())
            .doc(doc.toString())
            .collection(secCollection)
            .doc()
            .set(data);
}

firestore_update(collection, doc, data) async {
  try {
    EasyLoading.show();
    var dat = await FirebaseFirestore.instance
        .collection("$collection")
        .doc("$doc")
        .update(data);
    Get.snackbar("Data is added succesfully", "");
    EasyLoading.dismiss();
    return dat;
  } on FirebaseException catch (e) {
    EasyLoading.dismiss();
    Get.snackbar("${e.message}", "");
  }
}

addfav(List like, uid, collection, doc) async {
  if (like.contains(uid)) {
    await firestore_update(collection, doc, {
      "fav": FieldValue.arrayRemove([uid]),
    });
  } else {
    await firestore_update(collection, doc, {
      "fav": FieldValue.arrayUnion([uid]),
    });
  }
}

firestore_get(collection, doc) async {
  DocumentSnapshot userData =
      await FirebaseFirestore.instance.collection(collection).doc(doc).get();
  return userData;
}

pickImage(
  ImageSource source,
) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(
      source: source, imageQuality: 50, maxHeight: 600, maxWidth: 900);
  if (_file != null) {
    print(_file.name);

    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
