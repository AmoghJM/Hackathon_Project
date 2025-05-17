from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware

from .model import load_model, predict_from_audio
from .preprocessing import preprocess_audio  # placeholder

app = FastAPI()

# Enable CORS for Flutter app testing
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to specific frontend origin in production
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
    # Read audio file bytes
    audio_bytes = await file.read()
    
    # Preprocess audio to features
    features = preprocess_audio(audio_bytes)
    
    # Get prediction from model
    risk_score = predict_from_audio(model, features)
    
    # Return response
    return {
        "risk_score": risk_score,
        "message": "Prediction successful"
    }
