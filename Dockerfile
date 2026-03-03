FROM python:3

# 必要なOSパッケージをインストール (tjaf用のgit、文字変換用のnkf、プレビュー用のffmpeg)
RUN apt-get update && apt-get install -y \
    git \
    nkf \
    ffmpeg \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app

# pip自体を更新し、依存関係をインストール
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

ENV PYTHONUNBUFFERED 1

# Renderのポートに合わせて 0.0.0.0:34801 で起動
CMD ["gunicorn", "app:app", "--access-logfile", "-", "--bind", "0.0.0.0:34801"]
