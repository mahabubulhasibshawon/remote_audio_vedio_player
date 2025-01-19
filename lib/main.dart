import 'package:flutter/material.dart';
import 'package:remote_audio_vedio/screens/audio_player_screen.dart';
import 'package:remote_audio_vedio/screens/vedio_player_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: AudioPlayerScreen(),
    );
  }
}

