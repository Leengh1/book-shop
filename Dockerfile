FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir gunicorn 

COPY *.whl /app/

RUN pip install /app/*.whl

EXPOSE 4000
EXPOSE 3000

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1

ENTRYPOINT [ "gunicorn" ]
CMD [" --bind 0.0.0.0:4000 book_shop.wsgi:application"]

