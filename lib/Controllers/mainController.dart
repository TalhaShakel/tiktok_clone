import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreenController extends GetxController {
  // List<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  late VideoPlayerController controller;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  getData() async {
    
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }
}
