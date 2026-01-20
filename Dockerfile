FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
        build-essential \
        libpq-dev \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python tools including packaging
RUN pip install --upgrade pip setuptools wheel packaging \
    && pip install poetry

# Copy project files
COPY pyproject.toml poetry.lock* /app/
COPY app/ /app/

# Configure Poetry and install dependencies globally
RUN poetry config virtualenvs.create false \
    && poetry install --without dev --no-root

ENV PORT=80
EXPOSE $PORT

CMD ["sh", "-c", "poetry run gunicorn --bind 0.0.0.0:$PORT book_shop.wsgi:application"]
