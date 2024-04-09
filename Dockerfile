FROM python:3.10-slim
WORKDIR /app
COPY ChunksUpload.py .
RUN pip install Flask boto3
EXPOSE 8181
CMD ["python", "ChunksUpload.py"]