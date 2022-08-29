# Caterwaul
A simple chat app using Turbo Rails. A personal intern project by Noah Sawyer.

## Dependencies

To run this application, you will require the following

* Rails 7.0.3.1
* Ruby 3.1.2p20
* Redis
  * (Recommended) redis-cli
* Postgresql
* Nodejs

## Setup

On downloading the program for the first time, you will need to run:

```
rails db:create
```
Any time you pull, you should also make sure to run any pending migrations using:

```
rails db:migrate
```

## Starting the Application

To start the application, run the following commands in seperate terminals:

```
#terminal 1
rails s

#terminal 2
redis-server
```

After which, you should be able to connect to the application at `http://localhost:3000/`

## Closing the Application

To close the application, you will first need to kill the `rails s` process using `ctrl+C` in the terminal which is running it.

Then, you will need to enter the following command to shut down redis in a terminal which is not running redis:

```
redis-cli shutdown
```

## Styling

This project supports editorconfig and has a .editorconfig file saved in the root directory with the proper formatting included. See if your IDE has support to auto-format [here](https://editorconfig.org/). If it is working properly, it should fix your indentation and newline at EOF whenever you save your file.

This project also includes the `standardrb` linter. To see any formatting mistakes, call `bundle exec standardrb`, and to automatically fix your code, call `bundle exec standardrb --fix`.
