import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadButton extends StatefulWidget {
  final Function(String?) onFileSelected;

  const UploadButton({Key? key, required this.onFileSelected}) : super(key: key);

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  Future<void> _selectAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      widget.onFileSelected(result.files.single.path);
    } else {
      widget.onFileSelected(null); // No file selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _selectAudioFile,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2), // Semi-transparent white
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.1)), // Subtle border
        ),
        elevation: 2, // Add a slight elevation
        shadowColor: Colors.black.withOpacity(0.2), // Add a shadow
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.upload_file, color: Colors.white), // White icon
          SizedBox(width: 8),
          Text('Upload Audio File', style: TextStyle(color: Colors.white)), // White text
        ],
      ),
    );
  }
}