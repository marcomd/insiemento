describe ScheduleService do
  subject { described_class.call(**parameters) }
  let(:parameters) { { starting_date:, debug: } }
  let(:starting_date) { Date.parse('2020-02-22') }
  let(:debug) { false }

  describe '#call' do
    context 'when in debug mode' do
      let(:debug) { true }

      it { expect(subject).to be_an_instance_of(described_class) }

      it 'does NOT create any course events' do
        expect do
          expect(subject.result).to be_truthy
        end.to_not change(CourseEvent, :count)
      end
    end

    it 'creates course events' do
      expect do
        expect(subject.result).to be_truthy
      end.to change(CourseEvent, :count).by(70)
    end

    context 'when course events have been already created' do
      let(:starting_date) { CourseEvent.first.event_date } # The same date on the seed
      it 'does NOT create anymore' do
        expect do
          expect(subject.result).to be_truthy
        end.to change(SystemLog, :count).by(2) # One for each organization
      end
    end

    context 'when organization is passed as parameter' do
      before { parameters[:organization_ids] = [2] }

      it 'creates course events only for organizations set' do
        expect do
          expect(subject.result).to be_truthy
        end.to change(CourseEvent, :count).by(14)
      end
    end
  end
end
