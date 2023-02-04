class UserPresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper

  def unread_notifications_text
    unread_count = 4 # notifications.unread.count

    return "You don't have unread notifications." if unread_count == 0

    "You have %<unread_count>s unread %{pluralize(unread_count, 'notification')}"
  end
end
