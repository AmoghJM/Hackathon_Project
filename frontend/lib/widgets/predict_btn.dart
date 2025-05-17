import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:io';

class Predict extends StatefulWidget {
  final String? filePath;
  final Function(String) onResult;

  const Predict({Key? key, required this.filePath, required this.onResult})
    : super(key: key);

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
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
      style: ElevatedButton.styleFrom(
        backgroundColor:
            widget.filePath != null
                ? const Color(0xFF00C853) // Brighter Green when enabled
                : Colors.grey.shade800,
        // Darker grey when disabled
        foregroundColor: Colors.red,
        // Change text color to black
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      child:
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                "PREDICT",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Ensure text is black when enabled
                ),
              ),
    );
  }
}
