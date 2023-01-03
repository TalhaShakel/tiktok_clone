import 'package:flutter/material.dart';
import 'package:thiktok_clone/Controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:thiktok_clone/Views/screens/add_video_screen.dart';
import 'package:thiktok_clone/Views/screens/video_screen.dart';

List pages = [
  VideoScreen(),
  Text('Messages Screen'),
  const AddVideoScreen(),
  Text('Messages Screen'),
  Text('Messages Screen'),
];

//color
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
