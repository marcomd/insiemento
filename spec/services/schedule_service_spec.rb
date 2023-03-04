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
      let(:organization_id) { 2 }
      before { parameters[:organization_ids] = [organization_id] }

      it 'creates course events only for organizations set' do
        expect do
          expect(subject.result).to be_truthy
        end.to change(CourseEvent, :count).by(14)
      end

      context 'when no active course events are present' do
        before { CourseEvent.where(state: %i[active suspended]).update_all(state: :closed) }
        let(:course_event_dates) { CourseEvent.where(state: :active).pluck(:event_date).map(&:to_date) }
        let(:day_excursion) { (course_event_dates.last - course_event_dates.first).to_i }

        it 'creates course events with right dates' do
          expect(subject.result).to be_truthy
          expect(day_excursion).to eq(6)
        end

        context 'when course events event_day is not sequential' do
          let(:organization) { Organization.find(organization_id) }
          let(:category) { organization.categories.first }
          let(:course) { organization.courses.first }

          before do
            CourseSchedule.where(organization_id:).update_all(state: :suspended)
            # Let's create first an event on saturday
            create(:course_schedule, organization:, category:, course:, event_day: 6, event_time: '7:00', state: :active)
            # then an event on monday
            create(:course_schedule, organization:, category:, course:, event_day: 1, event_time: '8:00', state: :active)
          end

          it 'creates course events on the same week' do
            expect(subject.result).to be_truthy
            # The event on monday should be generated on the same week and not on the next one
            expect(day_excursion).to eq(5)
          end
        end
      end
    end
  end
end
