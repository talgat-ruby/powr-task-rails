require 'net/http'
require 'net/https'
require 'json'

class AuthController < ApplicationController
  def initialize
    @new_user = true
  end
  
  def login
    begin
      token_data = fetch_access_token()
      
      if token_data['error'].nil?
        access_token = token_data['access_token']
        user_data = fetch_user_data(access_token)
        save_user(user_data, access_token)
      else
        raise token_data['error']
      end
      
    rescue => e
      # move to fail
      puts "failed #{e}"
    end
  end
  
  def fetch_access_token()
    uri = URI('https://github.com/login/oauth/access_token')
    body = {
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      code: params[:code]
    }
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    })
    req.body = body.to_json
    res = http.request(req)
    
    if res.kind_of? Net::HTTPSuccess
      response_data = JSON.parse(res.body)
      return response_data
    elsif
      raise res.body 
    end
  end
  
  def fetch_user_data(access_token)
    uri = URI('https://api.github.com/user')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.path, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': " token #{access_token}"
    })
    res = http.request(req)
    
    if res.kind_of? Net::HTTPSuccess
      response_data = JSON.parse(res.body)
      return response_data
    elsif
      raise res.body 
    end
  end
  
  def save_user(data, access_token)
    user = User.find_or_initialize_by(uid: data['id'])
    if !user['id'].nil?
      @new_user = false
    end
    user.update_attributes!(
      username: data['login'],
      avatar_url: data['avatar_url'],
      email: data['email'],
      oauth_token: access_token
    )
    
    if user.valid?
      @user = user
      user.save
    else
      raise user.errors.full_messages
    end
  end

  def fail
  end
end
