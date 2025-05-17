# preprocessing.py
import numpy as np
import librosa
import io
import joblib
import os
import noisereduce as nr
from pydub import AudioSegment, silence

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SCALER_PATH = os.path.join(BASE_DIR, 'models', 'parkinsons_rf_scaler.joblib')

# Load the scaler
scaler = joblib.load(SCALER_PATH)


def normalize_volume(y, target_dBFS=-20):
    rms = np.sqrt(np.mean(y**2))
    scalar = 10 ** (target_dBFS / 20) / (rms + 1e-6)
    return y * scalar


def remove_silence_pydub(audio_bytes: bytes, silence_thresh=-40, min_silence_len=500):
    audio = AudioSegment.from_file(io.BytesIO(audio_bytes))
    chunks = silence.split_on_silence(audio,
                                      min_silence_len=min_silence_len,
                                      silence_thresh=silence_thresh)
    if not chunks:
        return audio_bytes  # Return original if silence removal fails
    combined = AudioSegment.silent(duration=0)
    for chunk in chunks:
        combined += chunk
    buffer = io.BytesIO()
    combined.export(buffer, format="wav")
    return buffer.getvalue()


def preprocess_audio(audio_bytes: bytes) -> np.ndarray:
    """
    Preprocesses raw audio: denoising, silence removal, normalization, and feature extraction.
    Returns scaled features ready for model prediction.
    """

    # Step 1: Remove silence
    audio_bytes = remove_silence_pydub(audio_bytes)

    # Step 2: Load cleaned audio with librosa
    y, sr = librosa.load(io.BytesIO(audio_bytes), sr=22050)

    # Auto-reject too short or too silent input
    if len(y) < sr or np.max(np.abs(y)) < 0.01:
        raise ValueError("Audio is too short or too quiet")

    # Step 3: Normalize volume
    y = normalize_volume(y)

    # Step 4: Noise reduction
    y = nr.reduce_noise(y=y, sr=sr)

    # Step 5: Feature extraction
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
    mfccs_mean = np.mean(mfccs, axis=1)  # shape (13,)

    # Pad to 22 features
    padded = np.pad(mfccs_mean, (0, 22 - len(mfccs_mean)), mode='constant')

    # Scale features
    scaled = scaler.transform(padded.reshape(1, -1))

    return scaled
