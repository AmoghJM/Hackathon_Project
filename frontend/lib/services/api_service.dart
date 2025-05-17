import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://172.17.5.100:8000'; // For Android Emulator
  // static const String baseUrl = 'http://10.0.2.2:8000'; // For Android Emulator

  static Future<String?> sendAudioFile(File audioFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', audioFile.path),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = jsonDecode(res.body);
        return "Risk Score: ${data['risk_score']}";
      } else {
        return "Failed: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
