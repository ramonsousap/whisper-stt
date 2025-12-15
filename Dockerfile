FROM nvidia/cuda:11.6.2-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    python3.9 \
    python3.9-distutils \
    python3-pip \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

RUN python3 -m pip install --upgrade pip

RUN pip install torch==1.13.1+cu116 torchaudio==0.13.1+cu116 \
    --extra-index-url https://download.pytorch.org/whl/cu116

RUN pip install numpy==1.23.5 python-multipart openai-whisper fastapi uvicorn

WORKDIR /app
COPY app /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10300"]
