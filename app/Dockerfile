FROM python:3.11-slim

WORKDIR /app

RUN pip install --upgrade pip
RUN pip install boto3 fastapi uvicorn

COPY . .

CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8080"]