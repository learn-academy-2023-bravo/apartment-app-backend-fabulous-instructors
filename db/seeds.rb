user1 = User.where(email: "testing1@example.com").first_or_create(password: "password", password_confirmation: "password")

user2 = User.where(email: "testing2@example.com").first_or_create(password: "password", password_confirmation: "password")

apartments1 = [
  {
    street: '45 Rimrock',
    unit: '90A',
    city: 'Dallas',
    state: 'TX',
    square_footage: 1000,
    price: '1800',
    bedrooms: 2,
    bathrooms: 2,
    pets: 'yes!',
    image: 'https://images.unsplash.com/photo-1469022563428-aa04fef9f5a2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1173&q=80'
  },
  {
    street: '345 Lightwave',
    unit: '3',
    city: 'Boulder',
    state: 'CO',
    square_footage: 1000,
    price: '1800',
    bedrooms: 2,
    bathrooms: 2,
    pets: 'yes!',
    image: 'https://images.unsplash.com/photo-1469022563428-aa04fef9f5a2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1173&q=80'
  }
]

apartments2 = [
  {
    street: '85 Humuhumunukunukuapua',
    unit: '5F',
    city: 'Maui',
    state: 'HI',
    square_footage: 1000,
    price: '1800',
    bedrooms: 2,
    bathrooms: 2,
    pets: 'yes!',
    image: 'https://images.unsplash.com/photo-1469022563428-aa04fef9f5a2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1173&q=80'
  }
]

apartments1.each do |apartment|
  user1.apartments.create(apartment)
  puts "creating: #{apartment}"
end

apartments2.each do |apartment|
  user2.apartments.create(apartment)
  puts "creating: #{apartment}"
end