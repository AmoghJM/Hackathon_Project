# Parkinson's Voice Analysis: Detecting Parkinson's Disease Through Voice

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)](https://dart.dev)

*Unleash the Power of Voice to Aid in Parkinson's Disease Detection.*

This Flutter application leverages the subtle changes in human voice to provide a preliminary risk assessment for Parkinson's Disease. By analyzing uploaded audio recordings, our intelligent backend processes vocal features and returns a risk score.

*Imagine:* A simple, accessible tool that could contribute to early detection efforts and empower individuals to seek timely medical advice.

## Key Features

* *Sleek and Intuitive User Interface:* A modern, dark theme with radium green accents for a visually engaging experience.
* *Effortless Audio Upload:* Easily upload pre-recorded audio files for analysis.
* *Intelligent Risk Assessment:* Our backend API (see below) analyzes the audio and provides a risk score.
* *Clear Prediction Result:* The application displays the risk score in a user-friendly format.
* *Cross-Platform Potential:* Built with Flutter, this app can be deployed on Android and iOS.


### Prerequisites

* *Flutter SDK:* Ensure you have the Flutter SDK installed on your machine. You can find installation instructions on the official Flutter website: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
* *Android Studio or VS Code:* A code editor with Flutter support is recommended (Android Studio or VS Code with the Flutter extension).


## Backend Integration 

* *Backend Technology:* The backend is built using Fast API.
* *API Endpoint:* The frontend communicates with the backend via the /predict endpoint.
* *Input:* The API expects an audio file as input.
* *Output:* The API returns a JSON response containing the risk_score.

*Without the backend running, the "PREDICT" button will not provide any meaningful results.*


* *Flutter:* The UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.
* *Dart:* The programming language for Flutter.
* *file\_picker:* For allowing users to select audio files from their device.
* *http:* For making network requests to the backend API.
* *lottie:* For displaying engaging animations (e.g., during loading).

## ML Models used
- Random Forest
- SVM
- XGBoost
