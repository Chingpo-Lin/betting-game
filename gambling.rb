
require 'sinatra'
require 'sinatra/reloader'

enable :sessions

get '/home' do
  erb(:home)  #looking for home.erb under views folder
end

get '/google' do
  redirect 'http://www.google.com'
end

get '/login' do
  if session[:user] != nil and session[:user].length > 0
    redirect '/game'
  end
  erb(:login)
end

get '/signup' do
  erb(:signup)
end

post '/check' do
  # puts("here")
  # puts(params["user"])
  # puts(params["password"])

  # means signup
  if params["confirm"]
    if params["confirm"] != params["password"]
      redirect '/signup?err=1'
    else
      redirect '/login'
    end
  else # login
    if !session[:user]
      session[:user] = ""
    end

    user = params["user"]
    pass = params["password"]
    if user == "123" and pass == "123"
      puts("success")
      session[:user] = user
      redirect '/game'
    else
      redirect '/login?err=1'
    end
  end
end

get '/game' do
  if !session[:user] or session[:user] == ""
    redirect '/login?err=2'
  end
  if !session[:win]
    session[:win] = 0
  end
  if !session[:loss]
    session[:loss] = 0
  end
  if !session[:profit]
    session[:profit] = 0
  end
  erb(:game)
end

get '/signout' do
  session[:user] = ""
  session[:win] = 0
  session[:loss] = 0
  session[:profit] = 0
  redirect '/login'
end

post '/play' do
  if !session[:win]
    session[:win] = 0
  end
  if !session[:loss]
    session[:loss] = 0
  end
  if !session[:profit]
    session[:profit] = 0
  end

  money = params["money"]
  guess = params["guess"]
  if !money or !guess or money == "" or guess == ""
    redirect '/game?err=1'
  end
  guess = guess.to_i
  money = money.to_i
  if guess < 1 or guess > 6
    redirect '/game?err=2'
  end

  dice = rand(6) + 1
  if dice == guess
    session[:win] = session[:win] + money * 2
  else

    session[:loss] = session[:loss] + money
  end
  session[:profit] = session[:win] - session[:loss]
  redirect "/game?dice=#{dice}&guess=#{guess}&money=#{money}"
end

not_found do
  erb(:notfound)
end
