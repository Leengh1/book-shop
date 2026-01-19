FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN pip install --upgrade pip setuptools wheel
RUN pip install poetry

COPY pyproject.toml poetry.lock /app/
COPY app/ /app/

RUN poetry install --no-dev

ENV PORT=80
EXPOSE 80

CMD ["sh", "-c", "poetry run gunicorn --bind 0.0.0.0:$PORT book_shop.wsgi:application"]
