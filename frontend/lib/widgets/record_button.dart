import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class RecordButton extends StatefulWidget {
  final Function(String) onStop;

  const RecordButton({Key? key, required this.onStop}) : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool isPlaying = false;
  String? _filePath;

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
    return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
  }

  Future<void> _startRecording() async {
    _filePath = await _getFilePath();
    await _recorder.startRecorder(toFile: _filePath, codec: Codec.pcm16WAV);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (_filePath != null) {
      widget.onStop(_filePath!); // Send to parent
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recording saved: $_filePath')));
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
          onPressed: () {
            // TODO: implement playback if needed
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          child: const Icon(Icons.play_arrow, color: Colors.amber),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}
