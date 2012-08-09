require 'bundler'
Bundler.require

require 'bcrypt'

require './models'

class PleaseExplain < Sinatra::Base
  enable :sessions

  helpers do
    def admin?
      # Exit if current_user is unset. Otherwise check the token.
      @user = user.first(email: current_user)
      if @user.nil?
        false
      else
        request.cookies['token'] == @user.token
      end
    end

    def protected!
      halt [ 401, 'Not userized' ] unless admin?
    end

    def current_user
      request.cookies["email"]
    end
  end

  before '/admin/*' do
    protected!
  end

  get '/' do
    erb :main
  end

  get '/admin/dashboard' do
    protected!

    erb :dashboard
  end


  # LOGIN / LOGOUT
  #____________________________________________________________________________
  get '/login/?' do
    erb :"login"
  end

  post '/login' do
    @user = User.first(email: params[:user][:email])

    if @user.nil?
      "No such email found"
    else
      if @user.password == params[:user][:password]
        @user.token = SecureRandom.hex
        @user.save
        response.set_cookie('email', value: @user.email, path:"/")
        response.set_cookie('token', value: @user.token, path:"/")
        redirect '/'
      else
        "Incorrect password"
      end
    end
  end

  get '/logout/?' do
    response.set_cookie(current_user, false)
    response.set_cookie('email', false)
    redirect '/'
  end

end