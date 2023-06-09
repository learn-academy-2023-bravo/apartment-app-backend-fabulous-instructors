# Apartment App

### Setup

- `rails new apartment-app-backend -d postgresql -T`
- `cd apartment-app-backend`
- `rails db:create`
- `bundle add rspec-rails`
- `rails generate rspec:install`

### Devise

- `bundle add devise`
- `rails generate devise:install`
- `rails generate devise User`
- `rails db:migrate`

### Apartments

- `rails g resource Apartment street:string unit:string city:string state:string square_footage:integer price:string bedrooms:integer bathrooms:float pets:string image:text user_id:integer`
- `rails db:migrate`

### Seeds

- `rails db:seed`

### GitHub

- `git checkout -b main`
- `git remote add origin https://github.com/learn-academy-2023-bravo/apartment-app-backend-<your-team>.git`
- `git add .`
- `git commit -m ':tada: initial commit'`
- `git push origin main`
- Ask for branch protection


## Updating the backend to use JWT with Devise

Before we add the Aunthentication steps, make sure your fetch calls are working before taking these steps.  
 - Read & Create (Update & Delete are stretch goals)
 - If Read isn't working, make sure you have migrated and seeded your database!
 - Don't get too hung up on the fetch methods.  What's important is that you have some time to work through the authentication steps, because there are many. 

*** Start with the Backend ***

## What is JWT and Why Use it?

JWT stands for JSON Web Token, and it is an open standard for securely transmitting information between parties as a JSON object. It is commonly used for authentication and authorization in web applications.

JWTs consist of three parts: the header, the payload, and the signature.

- The header is a small JSON object that tells us what kind of algorithm should be used to encrypt and decrypt the message.
- The payload is a JSON object that holds the actual information you want to share. You can include any data you want(i.e. name, expiration date). It is not encrypted.
- The signature is created by combining the encoded header, encoded payload, and a secret key using a specified algorithm.  It is lock that guarantees the token's integrity and authenticity. 

- When a user logs in, the server generates a JWT, signs it using a secret key, and sends it back to the client.
- The client stores the token, typically in local storage or a cookie, and includes it in subsequent requests to the server.
- The server can verify the authenticity of the token by validating the signature using the secret key.

JWTs are stateless, scalable, and customizable.  They can be used across different domains or services as they are self-contained.

## Steps for backend connection.
Do this very methodically.  Make sure everything goes in the right file/folder 

### 1. Add the following to your Gemfile: <br>
  `gem 'devise-jwt'` <br>
  `gem 'dotenv-rails', groups: [:development, :test]`<br>
   then run `bundle`

### 2. Update your CORS file

CORS which stands for Cross-Origin Resource Sharing. Our React frontend and Rails backend applications are running on two different servers. We have to tell the Rails app that (while in development) it is okay to accept requests from any outside domain.

Along with allowing requests, we will need to send a JWT token to the frontend through the headers.


 `config/initializers/cors.rb`
 ```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource '*',
    headers: ["Authorization"],
    expose: ["Authorization"],
    methods: [:get, :post, :put, :patch, :delete, :options, :head],
    max_age: 600
  end
end
```

### 4. Additional Devise Setup
We will also need to ensure that devise does not use flash messages since this is an API.

`api/config/initializers/devise.rb`
```ruby
config.navigational_formats = []
```

### 5. Additional Controllers and Routes for Devise
We need access to some additional files that devise has available to handle sign ups and logins.
```bash
 $ rails g devise:controllers users -c registrations sessions
```
We will replace the code in the registrations controller and sessions controller:
`app/controllers/users/registrations_controller.rb`
```ruby
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def create
    build_resource(sign_up_params)
    resource.save
    sign_in(resource_name, resource)
    render json: resource
  end
end
```

`app/controllers/users/sessions_controller.rb`
```ruby
# app/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    render json: resource
  end
  def respond_to_on_destroy
    render json: { message: "Logged out." }
  end
end
```
Then we need to update the devise routes: <br>
`config/routes.rb`
```ruby
Rails.application.routes.draw do
  get 'private/test'
  devise_for :users, 
    path: '', 
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
end
```

### 6. Create .env file and Generate JWT token
We need a secret key to create a JWT token. Generate one with this command:<br> $`bundle exec rake secret` <br>
A `.env` file is used to store api keys and secrets. These files should not be stored on github as then anyone could hack you.<br> 

***Make sure to add .env to your .gitignore!  This is very important!***

in your `.env` file, use the following syntax (this is convention for keys in `.env` files)
```ruby
DEVISE_JWT_SECRET_KEY=<your very long secret key here>
```
 ** do not use the angle brackets, nor do you need the key to be in quotes.

 ### 7. Configure Devise-JWT
 in your devise.rb file add the following - anywhere is fine, I added to bottom of my file.
 `config/initializers/devise.rb`
 ```ruby
 # api/config/initializers/devise.rb
  config.jwt do |jwt|
    jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}],
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 5.minutes.to_i
  end
  ```
### 8. Revocation
While there are several ways to revoke a token with devise-jwt, we are going to use the DenyList.
 1. Create denylist table:
 ```bash
 $ rails generate model jwt_denylist
 ```
 2. Update the migration file with the following code:
 ```ruby
def change
  create_table :jwt_denylist do |t|
    t.string :jti, null: false
    t.datetime :exp, null: false
  end
  add_index :jwt_denylist, :jti
end
```
3. `$ rails db:migrate`

4. Update the user model so that it uses JWT tokens. You will be removing part of the devise attributes. So it should look like this (plus your association)
`app/models/user.rb`
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
end
```

...and we're done!  Phew!  Run `rails s` to make sure you aren't getting errors.

## The End.

