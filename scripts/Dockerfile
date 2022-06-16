FROM python:alpine

WORKDIR /opt

COPY . .

RUN pip install -r requiremnts.txt

EXPOSE 5000

ENTRYPOINT ["python", "subscriber.py"]