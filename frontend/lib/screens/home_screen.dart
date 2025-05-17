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
  bool isPlaying = false;
  String? filePath;
  String result = "";

  void onRecordingStopped(String path) {
    setState(() {
      filePath = path;
    });
  }

  void onPredictionResult(String prediction) {
    setState(() {
      result = prediction;
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
                  repeat: isRecording || isPlaying,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RecordButton(
                      onStop: (path) {
                        onRecordingStopped(path);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Predict(filePath: filePath, onResult: onPredictionResult),
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
