FROM python:3.9-alpine

RUN apk add --update --no-cache g++ gcc libxslt-dev
WORKDIR /app
 # Copy the file to install dependencies text
COPY ./requirements.txt /app

RUN pip install -r requirements.txt
# Copy application files
COPY app /app

EXPOSE 5000

ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
