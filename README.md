# Products API

This is an API built with Ruby and Sinatra for authentication and product management.

## Installation

### Clone the Repository

```bash
git clone git@github.com:lucascheistwer/products-api.git
cd products-api
```

### Install Dependencies

```
bundle install
```

### Create .env file
```
cp .env.example .env
```
And then add a secure value to the JWT_SECRET_KEY variable in the .env

### Start the API

```
ruby app/app.rb
```
User credentials for authentication at `POST /auth/login` are:
- username: 'admin'
- password: 'password'

### Run Tests
```
bundle exec rspec app
```
