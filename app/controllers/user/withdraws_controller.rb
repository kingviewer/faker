class User::WithdrawsController < User::BaseController
  layout 'user_page'

  def new
    @title = 'Withdraw'
  end

  def index
    @title = 'Withdrawals'
  end

  def create
    get_cur_user
    if cur_user
      amount = BigDecimal(params[:withdraw][:amount], 6)
      if amount <= 0
        error('Invalid amount')
      elsif not valid_address?(params[:withdraw][:address])
        error('Invalid address')
      else
        User.where(id: cur_user.id).update_all(['token_balance = token_balance - ?', amount])
        cur_user.reload
        if cur_user.token_balance < 0
          User.where(id: cur_user.id).update_all(['token_balance = token_balance + ?', amount])
          error('Insufficient balance')
        else
          Withdraw.create(user: cur_user, amount: amount, address: params[:withdraw][:address])
          success
        end
      end
    else
      error('Only registered addresses are allowed')
    end
  end

  def list
    data = []
    if cur_user
      cur_user.withdraws.order(id: :desc).limit(params[:limit].to_i).offset(params[:limit].to_i * params[:page].to_i).each do |withdraw|
        data << {
          id: withdraw.id,
          formatted_amount: LZUtils.format_number(withdraw.amount, 6),
          state_name: withdraw.state_name,
          address: withdraw.address,
          created_at: withdraw.formatted_created_at
        }
      end
    end
    success(data)
  end
end
