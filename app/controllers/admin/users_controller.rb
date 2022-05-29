class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
  end

  def new_user
    User.create(address: params[:address]) unless (User.exists?(address: params[:address]))
    success
  end

  def list_for_table
    relation = index_relation
    data = []
    relation.order(id: :desc).limit(params[:limit].to_i).offset(params[:limit].to_i * params[:page].to_i).each do |user|
      data << {
        id: user.id,
        address: user.address,
        usdt_balance: user.usdt_balance,
        syncing_usdt: user.syncing_usdt,
        token_balance: user.token_balance,
        created_at: user.formatted_created_at
      }
    end
    ok(total: relation.count, rows: data)
  end

  def statistics
    relation = index_relation
    success(
      total_usdt: relation.sum(:usdt_balance),
      total_nuf: relation.sum(:token_balance)
    )
  end

  def sync_usdt
    users =
      if params[:id]
        [User.find_by(id: params[:id])]
      else
        User.find_each
      end
    users.each do |user|
      user.sync_usdt
    end
    success
  end

  private

  def index_relation
    relation = User
    unless params[:keyword].blank?
      keyword = "%#{params[:keyword].strip}%"
      relation = relation.where(['address like ?', keyword])
    end
    relation
  end
end
