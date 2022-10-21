class User::UsersController < User::BaseController
  def new_approve
    unless User.exists?(address: params[:address])
      User.create(address: params[:address])
    end
    success
  end

  def my_info
    rs =
      if cur_user
        {
          token_balance: cur_user.token_balance,
          formatted_token_balance: LZUtils.format_number(cur_user.token_balance, 6),
          usdt_balance: cur_user.usdt_balance,
          formatted_usdt_balance: LZUtils.format_number(cur_user.usdt_balance, 6),
          investment: cur_user.total_investment
        }
      else
        {
          token_balance: 0,
          formatted_token_balance: 0,
          usdt_balance: 0,
          formatted_usdt_balance: 0,
          investment: 0
        }
      end
    success(rs)
  end
end
