## Building image based on 3.5.2-jdk-8  
FROM maven:3.5.2-jdk-8 


## Copying all packges to 
COPY . /app

## Changing workspace to /app
WORKDIR  /app

## Cleaning local maven 
RUN mvn clean 

## Installing all packages 
RUN mvn install 

## Exposing docker port 
EXPOSE  8080

## Running application when container stared
CMD ["/bin/sh", "-c", "java -jar target/food_delivery-0.1.jar"]