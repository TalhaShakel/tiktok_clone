import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thiktok_clone/Controllers/mainController.dart';
import 'package:thiktok_clone/Views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatelessWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  // UploadVideoController uploadVideoController =
  //     Get.put(UploadVideoController());
  
  @override
  Widget build(BuildContext context) {
    final ConfirmScreenController confirmController =
        Get.put(ConfirmScreenController());
    confirmController.controller = VideoPlayerController.file(videoFile);

    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<ConfirmScreenController>(
            init: ConfirmScreenController(),
            builder: (_) {
              return Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: VideoPlayer(_.controller),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          child: TextInputField(
                            controller: _.songController,
                            labelText: 'Song Name',
                            icon: Icons.music_note,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          child: TextInputField(
                            controller: _.captionController,
                            labelText: 'Caption',
                            icon: Icons.closed_caption,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              //  uploadVideoController.uploadVideo(
                              //   _.songController.text,
                              //   _.captionController.text,
                              //   videoPath);
                            },
                            child: const Text(
                              'Share!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
