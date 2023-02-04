require 'spec_helper'

describe Api::Ui::V1::CourseEventsController, type: :api do
  let(:organization_id) { 1 }

  before do
    ENV['ORGANIZATION'] = '1'
    header 'Content-Type', 'application/json; charset=utf-8'
    header 'Accept-Language', language
    header 'X-Auth-Token', jwt_token
  end
  after(:all) do
    ENV.delete('ORGANIZATION')
  end

  let(:user) { user_stefania }
  let(:jwt_token) { authenticated_user(user.email) }
  let(:language) { 'it' }

  describe 'GET index' do
    let(:url) { '/api/ui/v1/course_events' }
    let(:action) { get url }

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
    let(:url) { "/api/ui/v1/course_events/#{course_event_id}" }
    let(:action) { get url }

    context 'without authentication' do
      let(:course_event_id) { stefania_subscribed_course_event_id }
      let(:jwt_token) { nil }

      it 'has no authorization' do
        action
        expect(last_response).to be_unauthorized
      end
    end

    context 'when subscribed' do
      let(:course_event_id) { stefania_subscribed_course_event_id }

      it 'returns the record' do
        action

        expect(json).to be_a(Hash)
        expect(json['errors']).to be_nil
        expect(last_response.status).to eq(200)

        expect(json['course']).to be_present
        expect(json['room']).to be_present
        expect(json['trainer']).to be_present
        expect(json['attendees_count']).to be_present
        expect(json['subscribed']).to eq(true)
      end
    end

    context 'when NOT subscribed' do
      let(:course_event_id) { stefania_unsubscribed_course_event_id }

      it 'returns the record' do
        action

        expect(json).to be_a(Hash)
        expect(json['errors']).to be_nil
        expect(last_response.status).to eq(200)

        expect(json['subscribed']).to eq(false)
      end
    end
  end

  describe 'PUT subscribe' do
    let(:url) { "/api/ui/v1/course_events/#{course_event_id}/subscribe" }
    let(:action) { put url, params.to_json } # rubocop:disable all
    let(:params) { { subscribe: } }

    let(:subscribe) { true }
    let(:course_event) do
      create(:course_event,
             organization:,
             course_schedule:,
             category: course_schedule.category,
             course: course_schedule.course,
             room: course_schedule.room,
             trainer: course_schedule.trainer,
             state:,
             event_date:)
    end
    let(:state) { :active }

    context 'when single request' do
      context 'when user tries to subscribe' do
        context 'when event is expired' do
          let(:organization) { Organization.find(organization_id) }
          let(:course_schedule) { organization.course_schedules.first }
          let(:event_date) { Time.zone.now - 1 }
          let(:course_event_id) { course_event.id }

          it do
            expect do
              action
              expect(json).to be_a(Hash)
              expect(last_response.status).to eq(422)
              expect(json['errors']).to be_present
              expect(json['errors']['course_event_id']).to include('Questa sessione non è più disponibile!')
            end.to_not change(Attendee, :count)
          end
        end

        context 'when event is not ready yet' do
          let(:organization) { Organization.find(organization_id) }
          let(:course_schedule) { organization.course_schedules.first }
          let(:event_date) { 8.days.from_now }
          let(:course_event_id) { course_event.id }

          it do
            expect do
              action
              expect(json).to be_a(Hash)
              expect(last_response.status).to eq(422)
              expect(json['errors']).to be_present
              expect(json['errors']['course_event_id']).to include('Non puoi ancora prenotarti per questa sessione, riprova più avanti.')
            end.to_not change(Attendee, :count)
          end
        end

        context 'when event is full' do
          before { stefania_unsubscribed_course_event.room.update(max_attendees: 0) }

          let(:course_event_id) { stefania_unsubscribed_course_event_id }

          it 'returns a max attendees reached' do
            expect do
              action
              expect(json).to be_a(Hash)
              expect(json['errors']).to be_present
              expect(json['errors']['course_event_id']).to include('È stato raggiunto il numero massimo di partecipanti!')
              expect(last_response.status).to eq(422)
            end.to_not change(Attendee, :count)
          end
        end

        context 'when user has not yet subscribed' do
          let(:organization) { Organization.find(organization_id) }
          let(:course_schedule) { organization.course_schedules.first }
          let(:course_event_id) { course_event.id }
          let(:event_date) { 2.hours.from_now }
          let(:course_event_id) { course_event.id }

          # Subscription let user to subscribe a course event
          context 'when user has an active subscription' do
            it 'can subscribes' do
              expect do
                action
                expect(json).to be_a(Hash)
                expect(json['errors']).to be_nil
                expect(last_response.status).to eq(200)
              end.to change(Attendee, :count).by(1)
            end

            context 'when user has a penalty' do
              let(:last_previuos_missed_attendee) do
                user.attendees.where(course_events: { course_id: course_event.course_id }).includes(:course_event).last
              end
              before { create(:user_penalty, user:, attendee: last_previuos_missed_attendee) }

              it 'cannot subscribe' do
                expect do
                  action
                  expect(json).to be_a(Hash)
                  expect(json['errors']).to be_present
                  expect(last_response.status).to eq(422)
                end.to_not change(Attendee, :count)
              end
            end
          end

          # Without active subscription user cannot partecipate to a course event
          context 'when user does NOT have an active subscription' do
            # let(:course_event_id) { stefania_unsubscribed_course_event_id }
            let(:user) { user_elena }

            it 'cannot subscribes' do
              expect do
                action
                expect(json).to be_a(Hash)
                expect(json['errors']).to be_present
                expect(json['errors']['course_event_id']).to include('Puoi procedere solo disponendo di un abbonamento, contattaci!')
                expect(last_response.status).to eq(422)
              end.to_not change(Attendee, :count)
            end
          end

          context 'when event is suspended' do
            let(:state) { :suspended }
            it do
              expect do
                action
                expect(json).to be_a(Hash)
                expect(last_response.status).to eq(422)
                expect(json['errors']).to be_present
                expect(json['errors']['course_event_id']).to include('Questa sessione è stata sospesa pertanto non è possibile iscriversi')
              end.to_not change(Attendee, :count)
            end
          end
        end

        context 'when user has already subscribed' do
          let(:course_event_id) { stefania_subscribed_course_event_id }

          it 'returns a unprocessable entity status' do
            expect do
              action
              expect(last_response.status).to eq(422)
              expect(json).to be_a(Hash)
              expect(json['errors']).to be_present
              expect(json['errors']['course_event_id']).to include('Iscrizione già presente per questo corso')
            end.to_not change(Attendee, :count)
          end
        end
      end

      # HERE !!! Verificare che lo user riattivi l'abbonamento a consumo
      context 'when user tries to UNsubscribe' do
        let(:subscribe) { false }

        context 'when user is not subscribed' do
          let(:course_event_id) { stefania_unsubscribed_course_event_id }

          it 'returns a status 404' do
            action
            expect(json).to be_a(Hash)
            expect(last_response.status).to eq(404)
          end
        end

        context 'when user is subscribed' do
          let(:course_event_id) { stefania_subscribed_course_event_id }

          it 'returns a status 200' do
            expect do
              action
              expect(json).to be_a(Hash)
              expect(json['errors']).to be_nil
              expect(last_response.status).to eq(200)
            end.to change(Attendee, :count).by(-1)
          end

          context 'when it is too late to unsubscribe' do
            let(:course_event) { CourseEvent.find(course_event_id) }
            let(:event_date) { 1.minute.ago }
            before { course_event.update(event_date:) }
            it do
              expect do
                action
                expect(json).to be_a(Hash)
                expect(last_response.status).to eq(422)
                expect(json['errors']).to be_present
                expect(json['errors']['course_event_id']).to include('Siamo spiacenti ma non è più possibile cancellarsi dalla lista.')
              end.to_not change(Attendee, :count)
            end
          end
        end
      end
    end

    context 'when multiple requests' do
      let(:organization) { Organization.find(organization_id) }
      let(:course_schedule) { organization.course_schedules.first }
      let(:course_event_id) { course_event.id }
      let(:event_date) { 2.hours.from_now }
      let(:course_event_id) { course_event.id }

      # Header doesn't change jwt token, find a way to change it to simulate requests from other users
      # pending 'sends multiple requests' do
      #   expect do
      #     threads = []
      #     threads << Thread.new do
      #       header 'X-Auth-Token', authenticated_user(user_stefania.email)
      #       action
      #     end
      #
      #     threads << Thread.new do
      #       sleep sleep_time
      #       header 'X-Auth-Token', authenticated_user(user_elena.email)
      #       action
      #     end
      #
      #     threads << Thread.new do
      #       header 'X-Auth-Token', authenticated_user(user_marco.email)
      #       action
      #     end
      #
      #     threads << Thread.new do
      #       header 'X-Auth-Token', authenticated_user(user_paolo.email)
      #       action
      #     end
      #
      #     threads << Thread.new do
      #       header 'X-Auth-Token', authenticated_user(user_linda.email)
      #       action
      #     end
      #
      #     threads.each(&:join)
      #   end.to change(Attendee, :count).by(4)
      # end
    end
  end

  describe 'GET attendees' do
    let(:url) { "/api/ui/v1/course_events/#{course_event_id}/attendees" }
    let(:action) { get url }
    let(:course_event_id) { stefania_subscribed_course_event_id }

    it 'returns a list' do
      action
      expect(last_response.status).to eq(200)
      expect(json).to be_a(Array)
      expect(json.size).to eq(10)
    end

    context 'without authentication' do
      let(:jwt_token) { nil }

      it 'has no authorization' do
        action
        expect(last_response).to be_unauthorized
      end
    end
  end

  describe 'PUT audit' do
    let(:url) { "/api/ui/v1/course_events/#{course_event_id}/audit" }
    let(:action) { put url, params.to_json } # rubocop:disable all
    let(:params) { { presences: { '1': true, '2': false, '3': false, '7': false, '8': false, '9': false, '10': false, '11': false, '12': false, '13': false } } }

    let(:course_event_id) { stefania_subscribed_course_event_id }

    context 'when user does NOT have authorization' do
      context 'when it does NOT have a trainer' do
        before { user.update(trainer_id: nil) }
        it do
          action
          expect(last_response.status).to eq(403)
          expect(json['errors']).to eq(['Operation not allowed'])
        end
      end
      context 'when it has a different trainer' do
        let(:course_event) { stefania_unsubscribed_course_event }
        before { user.update(trainer_id: course_event.trainer_id) }
        it do
          action
          expect(last_response.status).to eq(403)
          expect(json['errors']).to eq(['Operation not allowed'])
        end
      end
    end

    context 'when user have authorization' do
      let(:course_event) { CourseEvent.find(course_event_id) }
      before { user.update(trainer_id: course_event.trainer_id) }

      it do
        expect do
          action
          expect(json).to be_a(Hash)
          expect(json['errors']).to be_nil
          expect(last_response.status).to eq(200)
        end.to change { Attendee.where(presence: true).count }.by(1)
      end
    end
  end
end
