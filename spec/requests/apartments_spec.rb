require 'rails_helper'

RSpec.describe "Apartments", type: :request do
  let(:user) { User.create(
    email: 'test@example.com', 
    password: 'password',  
    password_confirmation: 'password'
    ) 
  }
 
  describe "GET /index" do
    it 'gets a list of apartments' do
      apartment = user.apartments.create(
        street: '4 Privet Drive',
        unit: '2A',
        city: 'Little Whinging',
        state: 'Surrey',
        square_footage: 2000,
        price: '2000',
        bedrooms: 3,
        bathrooms: 2,
        pets: 'yes',
        image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg' 
      )
      get '/apartments'

      apartment = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(apartment.first['street']).to eq('4 Privet Drive')
    end
  end
  
  describe "POST/create" do
    it 'creates an apartment' do
      apartment_params = {
        apartment: {
          street: '4 Privet Drive',
          unit: '2A',
          city: 'Little Whinging',
          state: 'Surrey',
          square_footage: 2000,
          price: '2000',
          bedrooms: 3,
          bathrooms: 2,
          pets: 'yes',
          image: 'https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg',
          user_id: user.id
        }
      }
      post '/apartments', params: apartment_params

      expect(response).to have_http_status(200)
      apartment = Apartment.first
      expect(apartment.street).to eq('4 Privet Drive')
      expect(apartment.unit).to eq('2A')
      expect(apartment.city).to eq('Little Whinging')
      expect(apartment.state).to eq('Surrey')
      expect(apartment.square_footage).to eq(2000)
      expect(apartment.price).to eq('2000')
      expect(apartment.bedrooms).to eq(3)
      expect(apartment.bathrooms).to eq(2)
      expect(apartment.pets).to eq('yes')
      expect(apartment.image).to eq('https://c8.alamy.com/comp/B0RJGE/small-bungalow-home-with-pathway-in-addlestone-surrey-uk-B0RJGE.jpg')
    end
  end
end
