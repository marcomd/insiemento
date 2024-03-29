require 'spec_helper'

describe Api::Ui::V1::ProductsController, type: :api do
  before do
    ENV['ORGANIZATION'] = '1'
    header 'Content-Type', 'application/json; charset=utf-8'
    header 'X-Auth-Token', jwt_token
    header 'Accept-Language', language
  end
  after(:all) do
    ENV.delete('ORGANIZATION')
  end
  let(:user) { user_stefania }
  let(:jwt_token) { authenticated_user(user.email) }
  let(:language) { 'it' }
  let(:action) { get url }

  describe 'GET index' do
    let(:url) { '/api/ui/v1/products' }

    it 'returns a list' do
      action
      expect(last_response.status).to eq(200)
      expect(json).to be_a(Array)
    end

    context 'without authentication' do
      let(:jwt_token) { nil }

      it 'has no authorization' do
        action
        expect(last_response).to be_unauthorized
      end
    end
  end

  describe 'GET show' do
    let(:url) { "/api/ui/v1/products/#{product_id}" }
    let(:product_id) { 1 }

    it 'returns the record' do
      action

      expect(json).to be_a(Hash)
      expect(json['errors']).to be_nil
      expect(last_response.status).to eq(200)

      expect(json['product_type']).to be_present
      expect(json['category_name']).to be_present
      expect(json['days']).to be_present
      expect(json['price']).to be_present
    end

    context 'without authentication' do
      let(:jwt_token) { nil }

      it 'has no authorization' do
        action
        expect(last_response).to be_unauthorized
      end
    end
  end
end
