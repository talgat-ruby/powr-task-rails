class AuthController < ApplicationController
  @@access_token = ''
  
  def login
    begin
      res = fetch_access_token()
      
      if token_res.kind_of? Net::HTTPSuccess
        response_data = JSON.parse(token_res.body)
        if response_data['error'].nil?
          access_token = response_data['access_token']
          user_res = fetch_user(access_token)
          # redirect_to('/auth/success')
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
  
  def fetch_access_token()
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
        return response_data
      elsif
        raise res.body 
      end
    rescue => e
      # move to fail
      puts "failed #{e}"
    end
  end
  
  def fetch_user(access_token)
    uri = URI('https://api.github.com/user')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.path, {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': " token #{access_token}"
    })
    return http.request(req)
  end

  def success
    
    user = User.new(
      uid: data['id'],
      username: data['login'],
      avatar_url: data['avatar_url'],
      email: data['email'],
      oauth_token: @@access_token
    )
    if user.valid?
      puts('VALID')
      puts user
      user.save
      @user = user
      puts @user
    end
  end

  def fail
  end
end
