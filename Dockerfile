FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel packaging

COPY app/*.whl /app/

RUN pip install /app/*.whl

ENV PORT=80
EXPOSE 80

CMD ["gunicorn", "--bind", "0.0.0.0:80", "book_shop.wsgi:application"]
