import 'package:flutter/material.dart';
import 'home_screen.dart'; // Assuming this file exists for voice detection
import 'symptom_checker.dart'; // Assuming this file exists for the symptom checker

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Setting background to black
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Parkinson Disease Detection', // Title text
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B9E5F), // Accent color for the title
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Choose a Method', // Title text
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70, // Accent color for the title
                ),
              ),
              const SizedBox(height: 50), // Space between title and buttons
              ElevatedButton(
                onPressed:
                    () => Navigator.push(
                      // Navigate to HomeScreen on press
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF36CC72),
                  // Green background for button
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text('Voice-based Detection'), // Button text
              ),
              const SizedBox(height: 20), // Space between buttons
              ElevatedButton(
                onPressed:
                    () => Navigator.push(
                      // Navigate to ParkinsonsSurvey on press
                      context,
                      MaterialPageRoute(builder: (_) => ParkinsonsSurvey()),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  // White-ish background for button
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text('Symptom Checker'), // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
