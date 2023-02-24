FROM python:3.8

RUN pip install fastapi uvicorn

EXPOSE 80

CMD ["uvicorn", "sample:app", "--host", "0.0.0.0", "--port", "80"]