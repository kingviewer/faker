class User::BaseController < ApplicationController
  before_action :get_cur_user

  def get_cur_user
    if (addr = params[:address] || cookies[:address])
      @cur_user ||= User.find_by(address: addr)
    end
  end

  def cur_user
    @cur_user
  end
end