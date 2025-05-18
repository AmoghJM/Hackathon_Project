import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ... rest of your code stays same
//pubspec.yaml
//dependencies:
//   flutter:
//     sdk: flutter
//   http: ^1.2.1

//AndroidManifest.xml
//add
//above application
//like this
// <manifest xmlns:android="http://schemas.android.com/apk/res/android">
//     <uses-permission android:name="android.permission.INTERNET"/>
//
//     <application
//         android:label="chat"
// <uses-permission android:name="android.permission.INTERNET"/>

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // REQUIRED!
//   await dotenv.load(fileName: '.env'); // Loads .env
//   runApp(ParkinsonsApp());
// }

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Load home after a delay
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => ParkinsonsSurvey()));
    });
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

// class ParkinsonsApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Parkinson\'s Checker',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: ParkinsonsSurvey(),
//     );
//   }
// }

class ParkinsonsSurvey extends StatefulWidget {
  @override
  _ParkinsonsSurveyState createState() => _ParkinsonsSurveyState();
}

class _ParkinsonsSurveyState extends State<ParkinsonsSurvey> {
  final Map<String, bool> symptoms = {
    'Are you experiencing mild tremors in your hands, arms, or legs?': false,
    'Have you noticed that your movements have become slower than usual?':
        false,
    'Do you have difficulty maintaining your balance or coordinating your movements?':
        false,
    'Has your voice become noticeably softer or quieter than it used to be?':
        false,
    'Are you experiencing difficulty sleeping?': false,
    'Do you feel depressed nowadays?': false,
    'Have you experienced changes in your memory or a slowdown in your thinking speed?':
        false,
  };

  final Map<String, int> scores = {
    'Are you experiencing mild tremors in your hands, arms, or legs?': 2,
    'Have you noticed that your movements have become slower than usual?': 2,
    'Do you have difficulty maintaining your balance or coordinating your movements?':
        2,
    'Has your voice become noticeably softer or quieter than it used to be?': 1,
    'Are you experiencing difficulty sleeping?': 1,
    'Do you feel depressed nowadays?': 1,
    'Have you experienced changes in your memory or a slowdown in your thinking speed?':
        1,
  };

  int calculateScore() {
    int total = 0;
    symptoms.forEach((key, value) {
      if (value) total += scores[key] ?? 0;
    });
    return total;
  }

  String getRiskMessage(int score) {
    if (score <= 4) return 'Low risk: No major concern. Monitor your symptoms.';
    if (score <= 9) return 'Moderate risk: Consider consulting a doctor.';
    return 'High risk: Please consult a neurologist for diagnosis.';
  }

  Future<void> sendToGemini(int score) async {
    final apiKey = dotenv.env['API_KEY']; // Replace with your Gemini key
    final symptomText = symptoms.entries
        .map((e) => '${e.key}: ${e.value ? "Yes" : "No"}')
        .join('\n');
    final baseUrl = dotenv.env['API_URL'];
    final url = Uri.parse('$baseUrl?key=$apiKey');

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": """
The user answered a Parkinson’s symptom checklist. These are the responses:

$symptomText

Total calculated score: $score

Based on the symptoms and score:
1. Give a short and clear explanation of what Parkinson’s Disease is.
2. Evaluate if the user's symptoms align with common early signs.
3. Provide a friendly, professional suggestion for whether they should consult a doctor.

Make sure the tone is not alarming, but informative.
""",
            },
          ],
        },
      ],
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
          "No suggestion received.";

      showDialog(
        context: context,
        builder: (_) {
          final scrollController = ScrollController();

          return AlertDialog(
            title: Text('Gemini Suggestion'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text, softWrap: true),
                      const SizedBox(height: 20),
                      const Text(
                        'Disclaimer: This suggestion is generated by an AI language model (Gemini) '
                        'and should not be considered a medical diagnosis. '
                        'Always consult a qualified healthcare professional for medical advice.',
                        style: TextStyle(fontSize: 12, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Error'),
              content: Text(
                'Gemini API Error: ${response.statusCode}\n${response.body}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  void handleSubmit() {
    final score = calculateScore();
    final message = getRiskMessage(score);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Your Assessment'),
            content: Text('Score: $score\n\n$message'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await sendToGemini(score);
                },
                child: Text('Ask Gemini'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parkinson\'s Symptom Checker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ...symptoms.keys.map((q) {
              return CheckboxListTile(
                title: Text(q),
                value: symptoms[q],
                onChanged: (val) {
                  setState(() => symptoms[q] = val ?? false);
                },
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(onPressed: handleSubmit, child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}
