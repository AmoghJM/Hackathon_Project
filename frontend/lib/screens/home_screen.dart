import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String? filePath;
  String result = "";

  @override
  void initState() {
    super.initState();
    recorder.openRecorder();
  }

  Future<void> startRecording() async {
    await Permission.microphone.request();
    Directory tempDir = await getTemporaryDirectory();
    filePath = "${tempDir.path}/recorded.wav";

    await recorder.startRecorder(toFile: filePath, codec: Codec.pcm16WAV);
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await recorder.stopRecorder();
    setState(() {
      isRecording = false;
    });
  }

  Future<void> sendAudio() async {
    if (filePath == null) return;

    final response = await ApiService.sendAudioFile(File(filePath!));
    setState(() {
      result = response ?? "No response from server.";
    });
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parkinson Detection")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: Text(isRecording ? "Stop Recording" : "Start Recording"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendAudio,
              child: const Text("Send for Prediction"),
            ),
            const SizedBox(height: 20),
            Text("Result: $result", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
