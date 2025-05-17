from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware

from .model import load_model, predict_from_audio
from .preprocessing import preprocess_audio

app = FastAPI()

# Enable CORS for Flutter app testing
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Update this to specific origin in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the model once on startup
model = load_model()

@app.get("/health")
def health_check():
    return {"status": "API is up and running"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        audio_bytes = await file.read()
        features = preprocess_audio(audio_bytes)
        risk_score, risk_percentage = predict_from_audio(model, features)

        return {
            "risk_score": float(risk_score),                # Ensure it's a native Python float
            "risk_percentage": str(risk_percentage),        # Ensure it's a native string
            "message": "Prediction successful"
        }
    except Exception as e:
        return {
            "error": str(e),
            "message": "Prediction failed"
        }
