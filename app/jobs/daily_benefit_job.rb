class DailyBenefitJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      user.daily_benefit
    end
  end
end
