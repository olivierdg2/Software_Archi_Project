# flutter_app

A new Flutter application.

## Context

This project is realized as part of the course of Architecture and software quality.

This application aims to list cows in a way of having a local database that you can synchronize with an online one.

## Installation

All dependencies are listed on the pubspec.yaml file. 

Once you've installed android studio and downloaded the repo run the project and do a "pub get" to get all dependencies.

## Views

In any view you got a header containing the name of the app and your connection status.

### Home (Cow list)

Here you can see the list of your registered cows and unregister them if needed. 

![alt text](https://github.com/olivierdg2/Software_Archi_Project/blob/master/README_images/home.png?raw=true)

### Add Cow

Here you can add a cow to your local database from an id and an optional description.

![alt text](https://github.com/olivierdg2/Software_Archi_Project/blob/master/README_images/Add_cow.png?raw=true)

### Synchronize (Logged out) 

Here you can either log you in or sign up. 

Click on the sign up button will open you the next view.

![alt text](https://github.com/olivierdg2/Software_Archi_Project/blob/master/README_images/Synchronize.png?raw=true)

### Sign up

Here you can sign up using an email and a password.

![alt text](https://github.com/olivierdg2/Software_Archi_Project/blob/master/README_images/Sign_up.png?raw=true)

### Synchronize (Logged in)

Here you can do multiple actions on your databases. 

The pull option will pull data from your online database to your local one overwriting it.

The push option will push data from your local database to your online one overwriting it.

You can also log out from your account.

![alt text](https://github.com/olivierdg2/Software_Archi_Project/blob/master/README_images/Synchronize_logged.png?raw=true)

