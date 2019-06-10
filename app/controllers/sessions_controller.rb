require 'net/http'
require 'net/https'
require 'json'

class SessionsController < ApplicationController
  @@access_token = ''
  
  def new
    begin
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
        # puts response_data
        if response_data['error'].nil?
          @@access_token = response_data['access_token']
          redirect_to('/sessions/create')
        else
          puts response_data['error']
        end
        puts("Success")
      elsif
        puts("Error")
      end
    rescue => e
      puts "failed #{e}"
    end
  end

  def create
    uri = URI('https://api.github.com/user')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.path, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': " token #{@@access_token}"
    })
    res = http.request(req)
    
    data = JSON.parse(res.body)
    
  end

  def destroy
  end
end
