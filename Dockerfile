FROM python:3

# 1. 必要なOSパッケージのインストール
# git: tjafのインストールに必要
# nkf: 文字コード変換コマンド (app.pyでsubprocessから呼ぶ用)
# ffmpeg: プレビュー作成用
RUN apt-get update && apt-get install -y \
    git \
    nkf \
    ffmpeg \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. アプリケーションの配置
COPY . /app
WORKDIR /app

# 3. 依存関係のインストール
# requirements.txt から nkf を削除していることを前提としています
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 4. 環境変数の設定
ENV PYTHONUNBUFFERED 1

# 5. 起動コマンド
CMD ["gunicorn", "app:app", "--access-logfile", "-", "--bind", "0.0.0.0:34801"]
