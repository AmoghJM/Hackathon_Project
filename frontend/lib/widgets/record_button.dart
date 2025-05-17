import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({Key? key}) : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool isPlaying = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
    return path;
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      _recordedFilePath = await _getFilePath();
      await _recorder.startRecorder(
        toFile: _recordedFilePath,
        codec: Codec.pcm16WAV,
      );
    } else {
      await _recorder.stopRecorder();
      if (_recordedFilePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording saved: $_recordedFilePath')),
        );
      }
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: _isRecording ? Colors.red : Colors.green,
              ),
            ),
            ElevatedButton(
              onPressed: () => {!isPlaying},
              child: Icon(Icons.play_arrow, color: Colors.amber),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
