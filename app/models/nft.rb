class Nft < ApplicationRecord
  belongs_to :user

  def release_amount
    case level
    when 1
      5
    when 2
      90
    when 3
      450
    when 4
      1800
    when 5
      3750
    else
      0
    end
  end

  def investment
    case level
    when 1
      500
    when 2
      3000
    when 3
      10000
    when 4
      30000
    when 5
      50000
    else
      0
    end
  end

end
