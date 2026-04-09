FROM python:3.11-slim

WORKDIR /app

COPY *.whl /app/

RUN pip install /app/*.whl

#EXPOSE 4000
#EXPOSE 3000

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
ENV PORT = 8000

ENTRYPOINT [ "gunicorn" ]
#CMD ["book_shop.wsgi:application", "--bind", "0.0.0.0:4000"]
ENTRYPOINT [ "sh", "-c", "gunicorn book_shop.wsgi:application --bind 0.0.0.0:${PORT:-8000}" ]

