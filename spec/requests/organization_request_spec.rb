describe 'OrganizationRequest', type: :request do

  let!(:organization) { create(:organization, domain: domain) }

  context 'when host has subdomain dsm' do
    let(:domain) { 'rspec' }
    let(:my_hostname) { "#{domain}.insiemento.local" }

    before(:all) do
      ENV['ORGANIZATION']=nil
    end

    it 'must set organization by subdomain' do
      host! my_hostname
      get '/users'
      expect(response.request.env['action_controller.instance'].send :current_organization).to eq organization
      expect(response).to have_http_status(:ok)
    end

    # it 'must redirect on /users' do
    #   host! my_hostname
    #   get '/'
    #   expect(response).to redirect_to('/users')
    #   expect(response.request.env['action_controller.instance'].send :current_organization).to eq organization
    # end

    it 'must show 404 page if no organization with same subdomain is found' do
      host! 'wrong.insiemento.local'
      # expect { get '/users' }.to raise_error(ActionController::RoutingError)
      get '/users'
      expect(response.body).to include "The page you were looking for doesn't exist"
    end
  end

  context 'when host has domain dsm.local' do
    let(:domain) { 'rspec.local' }
    let(:my_hostname) { domain }

    before(:all) do
      ENV['ORGANIZATION']=nil
    end

    it 'must set organization' do
      host! my_hostname
      get '/users'
      expect(response.request.env['action_controller.instance'].send :current_organization).to eq organization
      expect(response).to have_http_status(:ok)
    end

    # We have to work on this redirect
    # it 'must redirect on /users' do
    #   host! my_hostname
    #   get '/'
    #   expect(response).to redirect_to('/users')
    #   expect(response.request.env['action_controller.instance'].send :current_organization).to eq organization
    # end
  end

  context 'when ENV variable is set' do
    let(:domain) { 'rspec' }

    before(:all) do
      ENV['ORGANIZATION']='1'
    end
    after(:all) do
      ENV.delete 'ORGANIZATION'
    end

    it 'must set organization 1' do
      get '/users'
      expect(response.request.env['action_controller.instance'].send(:current_organization)&.id).to eq 1
      expect(response).to have_http_status(:ok)
    end
  end

  context 'when domain is standard' do
    let(:domain) { 'rspec.local' }

    before(:all) do
      ENV['ORGANIZATION']=nil
      host! CONFIG[:domains].first
    end

    it 'must set no organization' do
      get '/users'
      expect(response.request.env['action_controller.instance'].send :current_organization).to eq nil
      expect(response).to have_http_status(:ok)
    end

    context 'when organizazion param is present' do
      it 'must set organization by url param' do
        get "/users?organization=#{organization.uuid}"
        expect(response.request.env['action_controller.instance'].send :current_organization).to eq organization
        expect(response).to have_http_status(:ok)
      end

      it 'must show 404 page if no organization with same subdomain is found' do
        # expect { get '/users' }.to raise_error(ActionController::RoutingError)
        get '/users?organization=aaa'
        expect(response.body).to include "The page you were looking for doesn't exist"
      end
    end
  end
end
