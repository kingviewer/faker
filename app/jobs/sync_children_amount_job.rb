class SyncChildrenAmountJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      user.sync_children_amount
    end
  end
end
