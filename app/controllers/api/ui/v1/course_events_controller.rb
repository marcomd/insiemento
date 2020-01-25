class Api::Ui::V1::CourseEventsController < Api::Ui::BaseController
  before_action :set_course_event, except: [:index]

  respond_to :json

  EVENT_TIME_OFFSET = 3600

  def index
    # To simulate a network delay...
    simulate_delay_for_development
    @course_events = current_user.course_events.where(course_event_filter_params).includes(:course, :room, :trainer).order('course_events.id')
    if params[:state].present?
      if params[:state].downcase == 'active'
        @course_events = @course_events
                    .where(state: :active)
                    .where('event_date > ?', Time.zone.now+EVENT_TIME_OFFSET)
      elsif params[:state].downcase == 'closed'
        @course_events = @course_events
                             .where(state: :active)
                             .where('event_date < ?', Time.zone.now+EVENT_TIME_OFFSET)
      elsif params[:state] == 'ALL'
        # Do nothing
      else
        raise API::Exceptions::BadRequest, "Parameter state '#{params[:state]}' not recognized!"
      end
      # Questo parametro serve solo per filtrare le reservation
      params.delete :state
    end

    render :index
  end

  def show
    render :show
  end

  private

  def set_course_event
    @course_event = current_user.course_events.find(params[:id])
  end

  def course_event_filter_params
    params.permit(:course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state)
  end

  def course_event_params
    params.require(:course_event).permit(:course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state)
  end
end
