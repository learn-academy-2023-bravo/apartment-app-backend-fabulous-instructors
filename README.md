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
