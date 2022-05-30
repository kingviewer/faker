class SyncNftAmountJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      user.sync_nft_amount
    end
  end
end
