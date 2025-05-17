# model.py
import joblib
import numpy as np
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, 'models', 'parkinsons_xgboost_model.joblib')


def load_model():
    """
    Load the trained XGBoost model from disk.
    """
    try:
        model = joblib.load(MODEL_PATH)
        return model
    except Exception as e:
        print(f"Error loading model: {e}")
        return None

def predict_from_audio(model, features: np.ndarray):
    probability = model.predict_proba(features)[0][1]  # Class 1: Parkinson's
    return probability, f"{probability * 100:.2f}%"