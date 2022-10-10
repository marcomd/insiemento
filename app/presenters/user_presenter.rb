class UserPresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def unread_notifications_text
    unread_count = 4 #notifications.unread.count

    if unread_count == 0
      return "You don't have unread notifications."
    end

    "You have %{unread_count} unread %{pluralize(unread_count, 'notification')}"
  end
end