import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:io';

class Predict extends StatefulWidget {
  final String? filePath;
  final Function(String) onResult;

  const Predict({super.key, required this.filePath, required this.onResult});

  @override
  State<Predict> createState() => _predictState();
}

class _predictState extends State<Predict> {
  bool isLoading = false;

  Future<void> sendAudio() async {
    if (widget.filePath == null) return;

    setState(() {
      isLoading = true;
    });

    final response = await ApiService.sendAudioFile(File(widget.filePath!));

    setState(() {
      isLoading = false;
    });

    widget.onResult(response ?? "No response from server.");
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.filePath != null && !isLoading ? sendAudio : null,
      child:
          isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : const Text("PREDICT"),
    );
  }
}
