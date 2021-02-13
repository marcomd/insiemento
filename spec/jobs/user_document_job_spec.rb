require 'rails_helper'

RSpec.describe UserDocumentJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_later(user_document) }
  let(:user_document) { UserDocument.exporting_state.first }

  context 'when job is enqueued' do
    # We reset the queue manually so as not to affect next tests
    after {clear_enqueued_jobs}

    it { expect { subject }.to change(enqueued_jobs, :size).by(1) }

    it 'is in the proper queue' do
      expect(described_class.new.queue_name).to eq('user_documents')
    end
  end

  context 'when job is performed' do

    context 'when state is correct' do
      it do
        expect do
          VCR.use_cassette "otpservice/create_user_document_id_#{user_document.id}_status_201" do
            perform_enqueued_jobs{ subject }
          end
          user_document.reload
        end.to change(user_document, :state).from('exporting').to('exported')
      end
    end

    context 'when state is wrong' do
      let(:user_document) { UserDocument.draft_state.first }

      it do
        expect { perform_enqueued_jobs{ subject } }.to raise_exception /Event 'start_export' cannot transition from 'draft'/
      end
    end

    context 'when service call fails' do
      it do
        expect do
          VCR.use_cassette "otpservice/create_user_document_id_#{user_document.id}_status_422" do
            perform_enqueued_jobs{ subject }
          end
          user_document.reload
        end.to raise_exception(/UserDocumentJob failed/).and change(SystemLog, :count).by(1)
      end
    end
  end
end
