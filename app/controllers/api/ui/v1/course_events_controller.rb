class Api::Ui::V1::CourseEventsController < Api::Ui::BaseController
  before_action :set_course_event, except: [:index]

  respond_to :json

  EVENT_TIME_OFFSET = 3600

  def index
    # To simulate a network delay...
    simulate_delay_for_development
    @course_events = CourseEvent.where(course_event_filter_params).includes(:course, :room, :trainer).order('course_events.id ASC')
    if params[:subscribed]
      @course_events = @course_events.where(user_id: current_user.id)
    end
    if params[:state].present?
      if params[:state].downcase == 'active'
        @course_events = @course_events
                    .where(state: :active)
                    #.where('event_date > ?', Time.zone.now+EVENT_TIME_OFFSET)
      elsif params[:state].downcase == 'closed'
        @course_events = @course_events
                             .where(state: :closed)
                             #.where('event_date < ?', Time.zone.now+EVENT_TIME_OFFSET)
      elsif params[:state] == 'ALL'
        # Do nothing
      else
        raise API::Exceptions::BadRequest, "Parameter state '#{params[:state]}' not recognized!"
      end
      # This params is only used to filter above
      params.delete :state
    end

    render :index
  end

  def show
    render :show
  end

  def subscribe
    status =
      if course_event_filter_params[:subscribe] == true
        attendee = Attendee.new(user_id: current_user.id)
        @course_event.attendees << attendee
      else
        attendee = @course_event.attendees.find_by_user_id(current_user.id)
        attendee&.destroy
      end

    if status
      render :show
    elsif attendee
      render json: attendee.errors, status: :unprocessable_entity
    else
      render json: { course_event_id: [t('errors.messages.attending_not_found')] }, status: :not_found
    end
  end

  private

  def set_course_event
    @course_event = CourseEvent.find(params[:id])
  end

  def course_event_filter_params
    params.permit(:id, :course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state, :subscribe)
  end

  def course_event_params
    params.require(:course_event).permit(:course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state, :subscribe)
  end
end
