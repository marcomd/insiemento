# Le chiamate API sono effettuate verso localhost con VCR
# Di default sono ignorate e per registrarne di nuove è necessario modificare spec/support/vcr.rb
# c.ignore_localhost = false
describe OtpService do
  describe '#call' do
    let(:params) {}
    let(:service) { described_class.call(operation: operation, params: params) }
    let(:unsigned_document) do
      { filename: 'rspec.pdf',
        content: 'JVBERi0xLjMKJf////8KMSAwIG9iago8PCAvQ3JlYXRvciA8ZmVmZjAwNTAwMDcyMDA2MTAwNzcwMDZlPgovUHJvZHVjZXIgPGZlZmYwMDUwMDA3MjAwNjEwMDc3MDA2ZT4KPj4KZW5kb2JqCjIgMCBvYmoKPDwgL1R5cGUgL0NhdGFsb2cKL1BhZ2VzIDMgMCBSCj4+CmVuZG9iagozIDAgb2JqCjw8IC9UeXBlIC9QYWdlcwovQ291bnQgMQovS2lkcyBbNSAwIFJdCj4+CmVuZG9iago0IDAgb2JqCjw8IC9MZW5ndGggNjgKPj4Kc3RyZWFtCnEKCkJUCjM2LjAgNzQ3LjM4NCBUZAovRjEuMCAxMiBUZgpbPDQ2PiAzMCA8NmY2ZjIwNDI2MTcyPl0gVEoKRVQKClEKCmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iago8PCAvVHlwZSAvUGFnZQovUGFyZW50IDMgMCBSCi9NZWRpYUJveCBbMCAwIDYxMiA3OTJdCi9Dcm9wQm94IFswIDAgNjEyIDc5Ml0KL0JsZWVkQm94IFswIDAgNjEyIDc5Ml0KL1RyaW1Cb3ggWzAgMCA2MTIgNzkyXQovQXJ0Qm94IFswIDAgNjEyIDc5Ml0KL0NvbnRlbnRzIDQgMCBSCi9SZXNvdXJjZXMgPDwgL1Byb2NTZXQgWy9QREYgL1RleHQgL0ltYWdlQiAvSW1hZ2VDIC9JbWFnZUldCi9Gb250IDw8IC9GMS4wIDYgMCBSCj4+Cj4+Cj4+CmVuZG9iago2IDAgb2JqCjw8IC9UeXBlIC9Gb250Ci9TdWJ0eXBlIC9UeXBlMQovQmFzZUZvbnQgL0hlbHZldGljYQovRW5jb2RpbmcgL1dpbkFuc2lFbmNvZGluZwo+PgplbmRvYmoKeHJlZgowIDcKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDE1IDAwMDAwIG4gCjAwMDAwMDAxMDkgMDAwMDAgbiAKMDAwMDAwMDE1OCAwMDAwMCBuIAowMDAwMDAwMjE1IDAwMDAwIG4gCjAwMDAwMDAzMzMgMDAwMDAgbiAKMDAwMDAwMDU5OSAwMDAwMCBuIAp0cmFpbGVyCjw8IC9TaXplIDcKL1Jvb3QgMiAwIFIKL0luZm8gMSAwIFIKPj4Kc3RhcnR4cmVmCjY5NgolJUVPRgo=',
        sign_points: [
          { key: 'key_1', label: 'Terms and conditions', page: 1, top: 60, left: 10, required: true }
        ] }
    end

    context 'when operation is show' do
      let(:operation) { :show }
      let(:dossier_id) { 77 }
      let(:params) { { dossier_id: dossier_id } }
      let(:expected_status) { '200' }

      it 'returns the dossier' do
        VCR.use_cassette "otpservice/#{operation}_dossier_id_#{dossier_id}_status_#{expected_status}" do
          expect(service.errors).to_not be_present
          expect(service.success?).to eq true
          expect(service.result).to be_present
          expect(service.result['id']).to eq dossier_id
          expect(service.result['recipients'].first['email']).to eq 'plinio@rspec.com'
          expect(service.http_status).to eq expected_status
        end
      end

      # it 'creates a log' do
      #   VCR.use_cassette "otpservice/#{operation}_dossier_id_#{dossier_id}_status_#{expected_status}" do
      #     expect do
      #       service
      #     end.to change(SystemLog, :count)
      #   end
      # end

      context 'when dossier is NOT found' do
        let(:dossier_id) { 2 }
        let(:expected_status) { '404' }

        it 'returns a status 404' do
          VCR.use_cassette "otpservice/#{operation}_dossier_id_#{dossier_id}_status_#{expected_status}" do
            expect(service.success?).to eq false
            expect(service.result).to be_present
            expect(service.http_status).to eq expected_status
          end
        end
      end
    end

    context 'when operation is create' do
      let(:operation) { :create }
      let(:user_document_id) { 1_234_567 }
      let(:params) do
        { customer_dossier_id: user_document_id,
          unsigned_document: unsigned_document,
          recipients: [
            { first_name: 'Plinio', last_name: 'Il Vecchio', email: 'plinio@rspec.com', phone_prefix: '39', phone_number: '3334567890', language: 'it' }
          ] }
      end
      let(:expected_status) { '201' }

      it 'returns the dossier' do
        VCR.use_cassette "otpservice/#{operation}_user_document_id_#{user_document_id}_status_#{expected_status}" do
          expect(service.errors).to_not be_present
          expect(service.success?).to eq true
          expect(service.result).to be_present
          expect(service.result['recipients'].first['email']).to eq 'plinio@rspec.com'
          expect(service.result['state']).to eq 'notified'
          expect(service.http_status).to eq expected_status
        end
      end

      context 'but dossier already exists' do
        let(:expected_status) { '422' }

        it 'returns a status 422' do
          VCR.use_cassette "otpservice/#{operation}_user_document_id_#{user_document_id}_status_#{expected_status}_already_exists" do
            expect(service.success?).to eq false
            expect(service.result).to be_present
            expect(service.errors).to be_present
            expect(service.http_status).to eq expected_status
          end
        end
      end
    end

    context 'when operation is recreate' do
      let(:operation) { :recreate }
      let(:user_document_id) { 1_234_567 }
      let(:dossier_id) { 77 }
      let(:params) do
        { customer_dossier_id: user_document_id,
          dossier_id: dossier_id,
          unsigned_document: unsigned_document,
          recipients: [
            { first_name: 'Alaercio', last_name: 'Blasi', email: 'alaercio@rspec.com', phone_prefix: '39', phone_number: '3334455666', language: 'it' }
          ] }
      end
      let(:expected_status) { '201' }

      it 'returns the dossier' do
        VCR.use_cassette "otpservice/#{operation}_user_document_id_#{user_document_id}_status_#{expected_status}" do
          expect(service.errors).to_not be_present
          expect(service.success?).to eq true
          expect(service.result).to be_present
          expect(service.result['recipients'].first['email']).to eq 'alaercio@rspec.com'
          expect(service.result['state']).to eq 'notified'
          expect(service.http_status).to eq expected_status
        end
      end

      context 'but dossier has a different external id' do
        let(:user_document_id) { 11 }
        let(:dossier_id) { 78 }
        let(:expected_status) { '422' }

        it 'returns a status 422' do
          VCR.use_cassette "otpservice/#{operation}_user_document_id_#{user_document_id}_status_#{expected_status}" do
            expect(service.success?).to eq false
            expect(service.result).to be_present
            expect(service.errors).to be_present
            expect(service.http_status).to eq expected_status
          end
        end
      end
    end
  end
end
