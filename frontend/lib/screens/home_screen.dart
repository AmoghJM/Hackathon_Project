// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lottie/lottie.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import '../services/api_service.dart';
import '../widgets/record_button.dart';
import '../widgets/predict_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;
  bool isPlaying = false;
  String? filePath;
  String result = "";
  /*
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
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          color: const Color.fromARGB(255, 253, 170, 62),
          child: Center(
            child: Column(
              children: [
                Lottie.asset(
                  'assets/audio_loading.json',
                  width: 400,
                  height: 400,
                  fit: BoxFit.contain,
                  repeat: isRecording || isPlaying ? true : false,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const RecordButton()],
                ),
                const SizedBox(height: 20),
                const Predict(),
                const SizedBox(height: 20),
                Text(result, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
Column(
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
        */