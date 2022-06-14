class Admin::WithdrawsController < ApplicationController
  layout 'admin'

  def index
  end

  def list_for_table
    relation = Withdraw
    unless params[:keyword].blank?
      keyword = "%#{params[:keyword].strip}%"
      relation = relation.where(['address like ?', keyword])
    end
    data = []
    relation.order(id: :desc).limit(params[:limit].to_i).offset(params[:limit].to_i * params[:page].to_i).each do |withdraw|
      data << {
        id: withdraw.id,
        address: withdraw.address,
        amount: withdraw.amount,
        state: withdraw.state,
        state_name: withdraw.state_name,
        created_at: withdraw.formatted_created_at
      }
    end
    ok(total: relation.count, rows: data)
  end

  def transferred
    if not (withdraw = Withdraw.find_by(id: params[:id]))
      error('提现请求不存在')
    elsif not withdraw.pending?
      error('该提现请求不可操作')
    else
      withdraw.with_lock do
        if not withdraw.pending?
          error('该提现请求不可操作')
        else
          withdraw.success!
          AssetFlow.create(user: withdraw.user, flow_type: :withdraw, amount: -withdraw.amount, collected: true)
          success
        end
      end
    end
  end

  def refuse
    if not (withdraw = Withdraw.find_by(id: params[:id]))
      error('提现请求不存在')
    elsif not withdraw.pending?
      error('该提现请求不可操作')
    else
      withdraw.with_lock do
        if not withdraw.pending?
          error('该提现请求不可操作')
        else
          withdraw.refused!
          User.where(id: withdraw.user_id).update_all(['token_balance = token_balance + ?', withdraw.amount])
          success
        end
      end
    end
  end
end
