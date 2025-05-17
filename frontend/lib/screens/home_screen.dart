import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../widgets/record_button.dart';
import '../widgets/predict_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRecording = false;
  String? filePath;
  String result = "";

  void handleRecordingState(bool recording) {
    setState(() {
      isRecording = recording;
    });
  }

  void handleRecordingStop(String path) {
    setState(() {
      filePath = path;
    });
  }

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
                  repeat: isRecording, // reacts to HomeScreen's state
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RecordButton(
                      onStop: handleRecordingStop,
                      onRecordingStateChanged: handleRecordingState,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Predict(
                  filePath: filePath,
                  onResult: (String prediction) {
                    setState(() {
                      result = prediction;
                    });
                  },
                ),
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
