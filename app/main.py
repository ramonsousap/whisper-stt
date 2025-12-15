from fastapi import FastAPI, UploadFile, File
import whisper
import torch
import tempfile
import shutil

app = FastAPI()

DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
model = whisper.load_model("medium", device=DEVICE)

@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...), language: str = "pt"):
    with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as tmp:
        shutil.copyfileobj(file.file, tmp)
        tmp_path = tmp.name

    result = model.transcribe(tmp_path, language=language)
    return {
        "text": result["text"],
        "device": DEVICE
    }
