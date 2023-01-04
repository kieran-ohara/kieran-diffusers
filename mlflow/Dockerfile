FROM python:3.9

EXPOSE 5000

ENV DB_USERNAME admin
ENV DB_PASSWORD root
ENV DB_HOST localhost
ENV DB_PORT 3306
ENV DB_DATABASE test

ENV S3_BUCKET bucket
ENV AWS_ACCESS_KEY_ID id
ENV AWS_SECRET_ACCESS_KEY key

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

CMD /usr/local/bin/mlflow server \
      --default-artifact-root s3://$S3_BUCKET \
      --backend-store-uri mysql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_DATABASE} \
      --host 0.0.0.0
