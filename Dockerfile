FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV POETRY_VIRTUALENVS_CREATE=false

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel \
    && pip install "packaging<23" poetry

COPY pyproject.toml poetry.lock* /app/
COPY app/ /app/

RUN poetry install --without dev --no-root

ENV PORT=80
EXPOSE $PORT

CMD ["sh", "-c", "poetry run gunicorn --bind 0.0.0.0:$PORT book_shop.wsgi:application"]
