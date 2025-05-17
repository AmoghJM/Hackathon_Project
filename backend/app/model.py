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
    """
    Predict Parkinson's status using the trained model and input features.
    Returns 0 (Healthy) or 1 (Parkinson's).
    """
    prediction = model.predict(features)
    return int(prediction[0])
