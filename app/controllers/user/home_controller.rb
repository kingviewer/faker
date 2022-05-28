class User::HomeController < ApplicationController
  layout 'user'

  def index
    @inviter_address = params[:i]
  end
end
