FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry 

COPY pyproject.toml poetry.lock* /app/
RUN poetry install --no-root --only main

COPY . /app/

ENV PORT=80
EXPOSE $PORT

CMD ["sh", "-c", "poetry run gunicorn --bind 0.0.0.0:$PORT book_shop.wsgi:application"]
