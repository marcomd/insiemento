require "spec_helper"

describe Api::Ui::V1::AuthenticationController, type: :api do
  # include Rack::Test::Methods # Include this when type is "request"

  before do
    header 'Content-Type', 'application/json; charset=utf-8'
  end
  let(:user_password) { Rails.application.credentials.seed.dig(:default_password) }

  describe '#authenticate' do
    let(:url) { '/api/ui/v1/authenticate' }
    let(:authenticate_email)     { user.email }
    let(:authenticate_password)  { user_password }
    let(:params) { {email: authenticate_email, password: authenticate_password} }
    let(:action) { post url, params.to_json }
    let(:organization) { user.organization }

    context 'when request domain is correct' do
      let(:user) { user_stefania }
      let(:request_domain) { 'example.org' }
      let(:organization_domain) { request_domain }

      before do
        # I cant change request domain so i change organization value
        organization.update domain: organization_domain
        action
      end

      it 'returns a jwt token' do
        expect(last_response.status).to eq 200

        expect(json).to be_a(Hash)
        expect(json['auth_token']).to match /\A.{20}\..{30,60}\..{43}\Z/
        # Example Jwt:
        # eyJhbGciOiJIUzI1NiJ9.eyJjdXN0b21lcl9pZCI6MSwiZXhwIjoxNTYxMjA3NzM4fQ.Y4tfQKJRGUvigQDYXFk9R4ym-pkCnXX-fTYfxDwTKQs
        # Beware, it does not have a fixed length
      end

      context 'when password is wrong' do
        let(:authenticate_password) { 'A_wrong_password' }
        it { expect(last_response.status).to eq 401 } #unauthorized
      end

      context 'when user does not exist' do
        let(:authenticate_email) { 'pluto@abc.com' }
        it { expect(last_response.status).to eq 401 } #unauthorized
      end

      context 'when email has invalid format' do
        let(:authenticate_email) { 'pluto' }
        it { expect(last_response.status).to eq 401 } #unauthorized
      end

      # context 'when user exists under another organization' do
      #   let(:organization) { ... }
      #
      #   it 'returns a not found error' do
      #     expect(last_response).to be_unauthorized
      #     expect(json).to be_a(Hash)
      #     expect(json['error']).to be_present
      #   end
      # end
    end

    context 'when request domain has no organizations' do
      let(:user) { user_stefania }

      before { action }

      # The user organization has a domain fitness.io != request domain (example.org)
      it { expect(last_response.status).to eq 404 }
    end
  end

end
