class Withdraw < ApplicationRecord

  enum state: [:pending, :success, :refused]

  belongs_to :user

  def state_name
    if pending?
      'Pending'
    elsif success?
      'Success'
    elsif refused?
      'Refused'
    else
      '-'
    end
  end
end
