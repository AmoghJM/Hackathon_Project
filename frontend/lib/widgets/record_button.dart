import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class RecordButton extends StatefulWidget {
  final Function(String) onStop;
  final Function(bool) onRecordingStateChanged;

  const RecordButton({
    super.key,
    required this.onStop,
    required this.onRecordingStateChanged,
  });

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;
  late final RecorderController _waveformController;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _waveformController = RecorderController();
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
    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.pcm16WAV,
      audioSource: AudioSource.microphone,
    );
    await _waveformController.record(); // <-- corrected method name
    widget.onRecordingStateChanged(true);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    await _waveformController.stop(); // <-- await stop
    setState(() {
      _isRecording = false;
    });

    if (_filePath != null) {
      widget.onStop(_filePath!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recording saved: $_filePath')));
    }
    widget.onRecordingStateChanged(false);
  }

  Future<void> _toggleRecording() async {
    if (!_isRecording) {
      await _startRecording();
    } else {
      await _stopRecording();
    }
  }

  @override
  void dispose() {
    _waveformController.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isRecording)
          AudioWaveforms(
            size: const Size(double.infinity, 50),
            recorderController: _waveformController,
            enableGesture: false,
            waveStyle: const WaveformStyle(
              waveColor: Colors.blueAccent,
              extendWaveform: true,
              showMiddleLine: false,
            ),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleRecording,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: _isRecording ? Colors.red : Colors.green,
              ),
              child: Icon(_isRecording ? Icons.stop : Icons.mic),
            ),
          ],
        ),
      ],
    );
  }
}
