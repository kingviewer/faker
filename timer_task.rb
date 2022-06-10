require './config/boot'
require './config/environment'
require 'clockwork'

module TimerTask
  def self.sync_children_amount
    SyncChildrenAmountJob.perform_later
  end

  def self.sync_nft_amount
    SyncNftAmountJob.perform_later
  end

  def self.daily_benefit
    DailyBenefitJob.perform_later
  end
end

module Clockwork
  handler do |job|
    puts "执行 #{job}"
  end

  every(2.minute, '同步用户邀请人数') do
    TimerTask.sync_children_amount
  end

  every(3.minute, '同步用户持有NFT数量') do
    TimerTask.sync_nft_amount
  end

  every(1.day, '每日释放', at: '06:00') do
    TimerTask.daily_benefit
  end
end