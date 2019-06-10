require 'net/http'
require 'net/https'
require 'json'

class SessionsController < ApplicationController
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
      req = Net::HTTP::Post.new(uri.path, {'Content-Type': 'application/json', 'Accept': 'application/json'})
      req.body = body.to_json
      res = http.request(req)
      
      if res.kind_of? Net::HTTPSuccess
        response_data = JSON.parse(res.body)
        puts("Success")
      elsif
        puts("Error")
      end
    rescue => e
      puts "failed #{e}"
    end
  end

  def create
    puts("----------------------------------------------")
    puts("HELLLOOOOOOOOOOOOO!!!!!!!!!!!!!!!!!!!!!!!")
  end

  def destroy
  end
end
