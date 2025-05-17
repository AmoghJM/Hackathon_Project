import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:io';

class Predict extends StatefulWidget {
  const Predict({super.key});

  @override
  State<Predict> createState() => _predictState();
}

class _predictState extends State<Predict> {
  bool isPlaying = false;
  String? filePath;
  String? result;

  Future<void> sendAudio() async {
    if (filePath == null) return;

    final response = await ApiService.sendAudioFile(File(filePath!));
    setState(() {
      result = response ?? "No response from server.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Center(
      child: ElevatedButton(
        onPressed: sendAudio,
        child: Text("PREDICT"),
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          backgroundColor: const Color.fromARGB(255, 163, 145, 229),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    ));
  }
}
