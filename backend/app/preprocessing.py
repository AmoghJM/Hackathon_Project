# preprocessing.py
import numpy as np
import librosa
import io
import joblib
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SCALER_PATH = os.path.join(BASE_DIR, 'models', 'parkinsons_scaler.joblib')


# Load the scaler
scaler = joblib.load(SCALER_PATH)

def preprocess_audio(audio_bytes: bytes) -> np.ndarray:
    """
    Converts raw audio into a scaled feature vector for prediction.
    Currently uses MFCCs and pads/truncates to 22 features to match model.
    """
    # Load the audio using librosa
    y, sr = librosa.load(io.BytesIO(audio_bytes), sr=22050)

    # Extract 13 MFCCs
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
    mfccs_mean = np.mean(mfccs, axis=1)  # shape (13,)

    # Pad with zeros to get exactly 22 features
    padded = np.pad(mfccs_mean, (0, 22 - len(mfccs_mean)), mode='constant')  # shape (22,)

    # Reshape to (1, 22) and scale
    padded = padded.reshape(1, -1)
    scaled = scaler.transform(padded)

    return scaled
