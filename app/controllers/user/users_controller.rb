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
          formatted_token_balance: LZUtils.format_number(cur_user.token_balance, 6)
        }
      else
        {
          token_balance: 0,
          formatted_token_balance: 0
        }
      end
    success(rs)
  end
end
