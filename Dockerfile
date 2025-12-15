FROM nvidia/cuda:11.6.2-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    python3 python3-pip ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    torch==1.13.1+cu116 \
    torchaudio==0.13.1+cu116 \
    -f https://download.pytorch.org/whl/cu116 \
    openai-whisper fastapi uvicorn

WORKDIR /app
COPY app /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10300"]
