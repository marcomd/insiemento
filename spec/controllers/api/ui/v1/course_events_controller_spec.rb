require "spec_helper"

describe Api::Ui::V1::CourseEventsController, type: :api do
  let(:organization_id) { 1 }
  before(:all) do
    ENV['ORGANIZATION']='1'
  end
  after(:all) do
    ENV.delete 'ORGANIZATION'
  end

  before do
    header 'Content-Type', 'application/json; charset=utf-8'
    header 'X-Auth-Token', jwt_token
    header 'Accept-Language', language
  end
  let(:user) { user_stefania }
  let(:jwt_token) { authenticated_user(user.email) }
  let(:language) { 'it' }

  describe 'GET index' do
    let(:url) { '/api/ui/v1/course_events' }

    it 'returns a list' do
      get url
      expect(last_response.status).to eq 200
      expect(json).to be_a(Array)
    end

    context 'without authentication' do
      let(:jwt_token) { nil }

      it 'has no authorization' do
        get url
        expect(last_response).to be_unauthorized
      end
    end
  end

  describe 'GET show' do
    let(:url) { "/api/ui/v1/course_events/#{course_event_id}" }

    context 'without authentication' do
      let(:course_event_id) { stefania_subscribed_course_event_id }
      let(:jwt_token) { nil }

      it 'has no authorization' do
        get url
        expect(last_response).to be_unauthorized
      end
    end

    context 'when subscribed' do
      let(:course_event_id) { stefania_subscribed_course_event_id }

      it 'returns the record' do
        get url

        expect(json).to be_a(Hash)
        expect(json['errors']).to be_nil
        expect(last_response.status).to eq 200

        expect(json['course']).to be_present
        expect(json['room']).to be_present
        expect(json['trainer']).to be_present
        expect(json['attendees_count']).to be_present
        expect(json['subscribed']).to eq true
      end
    end

    context 'when NOT subscribed' do
      let(:course_event_id) { stefania_unsubscribed_course_event_id }

      it 'returns the record' do
        get url

        expect(json).to be_a(Hash)
        expect(json['errors']).to be_nil
        expect(last_response.status).to eq 200

        expect(json['subscribed']).to eq false
      end
    end
  end

  describe 'PUT subscribe' do
    let(:url) { "/api/ui/v1/course_events/#{course_event_id}/subscribe" }
    let(:params) { {subscribe: subscribe} }

    context 'when user tries to subscribe' do
      let(:subscribe) { true }
      let(:course_event) do
        create(:course_event,
               organization: organization,
               course_schedule: course_schedule,
               category: course_schedule.category,
               course: course_schedule.course,
               room: course_schedule.room,
               trainer: course_schedule.trainer,
               event_date: event_date)
      end

      context 'when events is expired' do
        let(:organization) { Organization.find(organization_id) }
        let(:course_schedule) { organization.course_schedules.first }
        let(:event_date) { Time.zone.now }
        let(:course_event_id) { course_event.id }

        it do
          put url, params.to_json

          expect(json).to be_a(Hash)
          expect(last_response.status).to eq 422
          expect(json['errors']).to be_present
          expect(json['errors']['course_event_id']).to include 'Questa sessione non è più disponibile!'
        end
      end

      context 'when events is not ready yet' do
        let(:organization) { Organization.find(organization_id) }
        let(:course_schedule) { organization.course_schedules.first }
        let(:event_date) { 3.days.from_now }
        let(:course_event_id) { course_event.id }

        it do
          put url, params.to_json

          expect(json).to be_a(Hash)
          expect(last_response.status).to eq 422
          expect(json['errors']).to be_present
          expect(json['errors']['course_event_id']).to include 'Non puoi ancora prenotarti per questa sessione, riprova più avanti.'
        end
      end

      context 'when events is full' do
        before { stefania_unsubscribed_course_event.room.update max_attendees: 0 }

        let(:course_event_id) { stefania_unsubscribed_course_event_id }

        it 'returns a max attendees reached' do
          put url, params.to_json

          expect(json).to be_a(Hash)
          expect(json['errors']).to be_present
          expect(json['errors']['course_event_id']).to include 'È stato raggiunto il numero massimo di partecipanti!'
          expect(last_response.status).to eq 422
        end
      end

      context 'when user has not yet subscribed' do
        let(:organization) { Organization.find(organization_id) }
        let(:course_schedule) { organization.course_schedules.first }
        let(:course_event_id) { course_event.id }
        let(:event_date) { Time.zone.now + 2.hours }
        let(:course_event_id) { course_event.id }

        # Subscription let user to subscribe a course event
        context 'when user has an active subscription' do
          it 'can subscribes' do
            put url, params.to_json

            expect(json).to be_a(Hash)
            expect(json['errors']).to be_nil
            expect(last_response.status).to eq 200
          end
        end

        # Without active subscription user cannot partecipate to a course event
        context 'when user does NOT have an active subscription' do
          # let(:course_event_id) { stefania_unsubscribed_course_event_id }
          let(:user) { user_elena }

          it 'cannot subscribes' do
            put url, params.to_json

            expect(json).to be_a(Hash)
            expect(json['errors']).to be_present
            expect(json['errors']['course_event_id']).to include 'Puoi procedere solo disponendo di un abbonamento, contattaci!'
            expect(last_response.status).to eq 422
          end
        end
      end

      context 'when user has already subscribed' do
        let(:course_event_id) { stefania_subscribed_course_event_id }

        it 'returns a unprocessable entity status' do
          put url, params.to_json

          expect(last_response.status).to eq 422

          expect(json).to be_a(Hash)
          expect(json['errors']).to be_present
          expect(json['errors']['course_event_id']).to include 'Iscrizione già presente per questo corso'
        end
      end
    end

    context 'when user tries to UNsubscribe' do
      let(:subscribe) { false }

      context 'when user is not subscribed' do
        let(:course_event_id) { stefania_unsubscribed_course_event_id }

        it 'returns a status 404' do
          put url, params.to_json

          expect(json).to be_a(Hash)
          expect(last_response.status).to eq 404
        end
      end

      context 'when user is subscribed' do
        let(:course_event_id) { stefania_subscribed_course_event_id }

        it 'returns a status 200' do
          put url, params.to_json

          expect(json).to be_a(Hash)
          expect(json['errors']).to be_nil
          expect(last_response.status).to eq 200
        end
      end
    end
  end

end
