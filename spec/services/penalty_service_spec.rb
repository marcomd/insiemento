require 'rails_helper'

describe PenaltyService do
  subject { described_class.call(starting_date:, debug:) }

  let(:event_date) { 1.day.ago }
  let(:starting_date) { event_date.to_date }
  let(:debug) { false }
  let(:duplicated_service) { described_class.call(starting_date:, debug:) }
  let(:organization) { organization_fitness }
  let(:penalty_category) { category_fitness }
  let(:penalty_course) { nil }
  let(:penalty) { create(:penalty, organization:, category: penalty_category, course: penalty_course) }
  let(:course_event) do
    create(:course_event,
           organization:,
           category: category_fitness,
           course: course_fitness_zumba,
           state: :active,
           event_date:)
  end
  # Dopo il seed lo user è senza abbonamento, verificare
  let(:user) { user_linda }
  let(:attendee) { create(:attendee, user:, course_event:, presence:, disable_bookability_checks: true) }
  let(:presence) { false }

  describe '#call' do
    context 'when in debug mode' do
      let(:debug) { true }

      before do
        penalty
        course_event
        attendee
      end

      it { expect(subject).to be_an_instance_of(described_class) }
      it do
        expect do
          expect(subject.result).to be_truthy
        end.to_not change(UserPenalty, :count)
      end
    end

    context 'when nobody have missing penalties' do
      let(:presence) { true }

      before do
        penalty
        course_event
        Attendee.update_all(presence: true)
        attendee
      end

      it do
        expect do
          expect(subject.result).to be_truthy
        end.to_not change(UserPenalty, :count)
      end
    end

    context 'when someone have a missing penalty' do
      let(:presence) { false }

      before do
        course_event
        Attendee.update_all(presence: true)
        attendee
      end

      context 'when organization does NOT have set any penalties' do
        it do
          expect do
            expect(subject.result).to be_truthy
          end.to_not change(UserPenalty, :count)
        end
      end

      context 'when organization have set a penalty' do
        before { penalty }

        it do
          expect do
            expect(subject.result).to be_truthy
          end.to change(UserPenalty, :count).by(1)
        end

        context 'when service runs twice' do
          let(:another_attendee) { create(:attendee, user: user_marco, course_event:, presence:, disable_bookability_checks: true) }

          it do
            expect do
              expect(subject.result).to eq(1)
              another_attendee
              # It returns only the just created one
              expect(duplicated_service.result).to eq(1)
            end.to change(UserPenalty, :count).by(2)
          end
        end

        context 'when there are more course events' do
          let(:another_course_event) do
            create(:course_event,
                   organization:,
                   category: category_fitness,
                   course: course_fitness_yoga,
                   state: :active,
                   event_date:)
          end
          let!(:another_attendee) { create(:attendee, user: user_marco, course_event: another_course_event, presence:, disable_bookability_checks: true) }

          it do
            expect do
              expect(subject.result).to eq(2)
            end.to change(UserPenalty, :count).by(2)
          end

          context 'when penalty considers only a specific course' do
            let(:penalty_course) { course_fitness_zumba }

            it do
              expect do
                expect(subject.result).to eq(1)
              end.to change(UserPenalty, :count).by(1)
            end
          end
        end
      end
    end

    # it 'creates course events' do
    #   expect do
    #     expect(subject.result).to be_truthy
    #   end.to change(CourseEvent, :count).by(70)
    # end
    #
    # context 'when course events have been already created' do
    #   let(:starting_date) { CourseEvent.first.event_date } # The same date on the seed
    #   it 'does NOT create anymore' do
    #     expect do
    #       expect(subject.result).to be_truthy
    #     end.to change(SystemLog, :count).by(2) # One for each organization
    #   end
    # end
  end
end
