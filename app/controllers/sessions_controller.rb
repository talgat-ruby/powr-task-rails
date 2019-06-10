require "http"

class SessionsController < ApplicationController
  def new
    puts('NEW!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    args = { client_id: ENV['CLIENT_ID'] }
    redirect_to 'https://github.com/login/oauth/authorize?' + args.to_query
  end

  def create
    puts("----------------------------------------------")
    puts("HELLLOOOOOOOOOOOOO!!!!!!!!!!!!!!!!!!!!!!!")
  end

  def destroy
  end
end
