FROM python:3.8.13-slim-buster

COPY ./app/reqiurements.txt reqiurements.txt

RUN pip3 install -r reqiurements.txt

WORKDIR /app

COPY ./app .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
