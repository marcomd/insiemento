class OrganizationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "organization_#{params[:uuid]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
