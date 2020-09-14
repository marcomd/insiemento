class UpdateUsersJob < ApplicationJob
  queue_as :users

  def perform
    User.find_in_batches(batch_size: 100) do |group|
      sleep(3) unless Rails.env.test?
      group.each { |user| user.save }
    end
  end
end
