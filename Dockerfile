FROM python:3-alpine
WORKDIR /usr/src/app
EXPOSE 8000
COPY requirements.txt .
RUN pip install -qr requirements.txt
COPY server.py .

HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

CMD ["python3", "./server.py"]

