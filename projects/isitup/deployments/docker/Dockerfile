FROM python:3

## Copy everything to image folder root
WORKDIR /app
COPY ./isitup /app
COPY ./isitup/configurations/domains.yaml /app/domains.yaml

## Putting inside Docker file which environment is 
ARG version
ENV RELEASE=$version

## Create kube folder insied root Copy KuberConfig to the docker images
RUN mkdir /root/.kube


## Install all requirements to the docker image
RUN python -m pip install -r requirements.txt


## Expose the port 5000
EXPOSE 5000


## To run this docker image need commmand
CMD ["/bin/sh", "-c", "python /app/app.py"]