## Based image
FROM python:3

WORKDIR /app
COPY ./data-miner /app

RUN mkdir /root/.kube
## Install all packages
RUN python -m pip install -r requirements.txt


## Expose the port 5000
EXPOSE 5000

## Run the application
CMD ["/bin/sh", "-c", "python /app/app.py"]
