describe UserDocumentsManagerService do
  let(:debug) { false }
  subject { described_class.call(debug: debug) }

  it { expect(subject).to be_an_instance_of(described_class) }

  describe '#call' do
    context 'when many records have been already created' do
      it 'creates only for user without one' do
        expect do
          subject
        end.to change(UserDocument, :count).by(1)
      end
    end

    context 'when user documents are expired' do
      let(:future_date) { Time.zone.now + 1.month.from_now }
      it do
        Timecop.freeze future_date do
          expect do
            subject
          end.to change { UserDocument.to_expire.count }.by(-3)
        end
      end

      context 'when document model is NOT recurring' do
        before { UserDocumentModel.first.update(recurring: false) }
        it 'creates only for new users' do
          Timecop.freeze future_date do
            expect do
              subject
            end.to change(UserDocument, :count).by(1)
          end
        end
      end

      context 'when document model is recurring' do
        before { UserDocumentModel.first.update(recurring: true) }
        it 'creates user documents for all users' do # ...also user who had one that now is expired
          Timecop.freeze future_date do
            expect do
              subject
            end.to change(UserDocument, :count).by(4)
          end
        end
      end
    end

    context 'when in debug mode' do
      let(:debug) { true }

      it do
        expect do
          subject
        end.to_not change(UserDocument, :count)
      end
    end
  end
end
