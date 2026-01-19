FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock* /app/
COPY app/ /app/

RUN poetry config virtualenvs.create false
RUN poetry install --without dev

ENV PORT=80
EXPOSE 80

CMD ["sh", "-c", "poetry run gunicorn --bind 0.0.0.0:$PORT book_shop.wsgi:application"]
