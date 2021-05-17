# food_delivery_project

## To deploy

- To create a build file 
```shell script
./mvnw install
```
If you see `BUILD SUCCESS` then the build is done.

- To run executable file 
```shell script
java -jar target/food_delivery-0.1.jar
```

- To test if it is running, go to browser and check url
```
http://localhost:8080/food/list
```

# Spring Project 1
This is project repository which will be followed throughout the course.
At the end of this project you will have fully functional simple food delivery application - let us call it <strong>Lagman House</strong>.

* Each issue represents one/severeal chapters from the course.
* Some issues will be related to other issues - it will be defined inside the issuse.
* Each issue should be done in seperate branch.

## Central asian food Restaurant marketplace
This marketplace sells and delivers various CA dishes. 
I see this project in two parts:
Basic : Only one restaurant which sells various dishes and users buys from this restaurant
Advanced : More restaurants can be added and sell dishes. User can buy dishes from several restaurants at the same time. 

### Basic Part: 
#### Requirements
* A guest user should be able to:
** register into the system with a unique username and password.
** login into the system given some valid credentials.
** see all the dish catalog as well as search per dish category.
* A registered user should be able to:
** add dishes to the shopping cart.
** remove dishes from the shopping cart.
** modify the quantity of a particular dish in the shopping cart.
** check out the shopping cart, which involves:
** sending the user id and cart to an external payment system (see below).
** persisting order details including the Payment ID.
** list existing orders as well as retrieving a specific one by id.
** log out of the system.

* An admin user should be able to:
** add restaurant
** add categories.
** add dishes to the catalog.
** modify the prices of dishes.

* The frontend should be able to:
** Some stuff
** consume data using an HTTP API that we need to define.

--- External payment system : Fake ready payment system can be used just for demonstration purposes (https://beeceptor.com/)
#### Domain

* Dish 
Uuid : a unique dish identifier
Name: name of the dish (lagman, manty and etc…)
Category: dish category (appetizers, main dish, desert, beverages) relationship with category entity
Description: Description and maybe ingredients
Price: in USD currency with two decimal digits

* Category
Name: name of the category , can not be duplicated

* Cart
uuid: a unique cart identifier.
Dishes:  a key-value store (Map) of dishe ids and quantities.

* Order
uuid: a unique order identifier.
paymentId: a unique payment identifier given by a 3rd party client.
dishes: a key-value store (Map) of dishe ids and quantities.
total: the total amount of the order, in USD.

* Card
name: card holder’s name.
number: a 16-digit number.
expiration: a 4-digit number as a string, to not lose zeros: the first two digits
indicate the month, and the last two, the year. i.e. “0821”.
ccv: a 3-digit number. CCV stands for Card Verification Value.
Roles and Users: 
GuestUser
Since we don’t know anything about such users, we are not going to represent them in
our domain model but we know they should be able to register and login into the system
given some valid credentials.

* User
Represents a registered user that has been logged into the system.
** uuid: a unique user identifier.
** username: a unique username registered in the system.
** password: the username’s password.

* AdminUser
It has special permissions such as adding dishes into the system’s catalog.
** uuid: a unique admin user identifier.
** username: a unique admin username.

#### Architecture


Postgres / MySQL database to store persistent data like Dishes Users and etc..
Redis to store cash data for fast access like shopping cart and dispose at the end.

