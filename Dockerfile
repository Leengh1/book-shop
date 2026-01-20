FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV POETRY_VIRTUALENVS_CREATE=false
ENV PORT=80
ENV PYTHONPATH=/app

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel \
    && pip install "packaging==21.3" "poetry==1.6.1"

COPY pyproject.toml poetry.lock* /app/
RUN poetry install --no-root --only main

COPY . /app/

EXPOSE $PORT

CMD ["sh", "-c", "poetry run gunicorn --bind 0.0.0.0:${PORT} app.book_shop.wsgi:application"]
