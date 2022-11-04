
require 'sinatra'
require 'sinatra/reloader'
require './user'

enable :sessions

get '/home' do
  @home = 1
  erb(:home)  #looking for home.erb under views folder
end

get '/google' do
  redirect 'http://www.google.com'
end

get '/login' do
  @login = 1
  if session[:user] != nil and session[:user].length > 0
    redirect '/game'
  end
  erb(:login)
end

get '/signup' do
  @signup = 1
  erb(:signup)
end

post '/check' do
  # puts("here")
  # puts(params["user"])
  # puts(params["password"])

  # means signup
  if params["confirm"]
    if params["password"].length < 3 or params["confirm"].length < 3 or params["user"].length < 3
      redirect '/signup?err=1'
    elsif params["confirm"] != params["password"]
      redirect '/signup?err=2'
    elsif User.first(username: params["user"])
      redirect '/signup?err=3'
    else
      User.create(username: params["user"], password: params["password"],
                  total_win: 0, total_loss: 0, total_profit: 0)
      redirect '/login'
    end
  else # login
    if !session[:user]
      session[:user] = ""
    end

    user = params["user"]
    pass = params["password"]
    if User.first(username: user) and User.first(username: user).password == pass
      session[:user] = user
      redirect '/game'
    else
      redirect '/login?err=1'
    end
  end
end

get '/game' do
  @game = 1
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
  unless session[:msg]
    session[:msg] = []
  end
  user = User.first(username: session[:user])
  @totalWin = user.total_win
  @totalLoss = user.total_loss
  @totalProfit = user.total_profit
  erb(:game)
end

get '/signout' do
  session[:user] = ""
  session[:win] = 0
  session[:loss] = 0
  session[:profit] = 0
  session[:msg] = []
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
  if money < 0
    redirect '/game?err=3'
  end

  dice = rand(6) + 1
  user = User.first(username: session[:user])
  say = []
  if dice == guess
    session[:win] = session[:win] + money * 2
    user.total_win = user.total_win + money * 2
    user.total_profit = user.total_profit + money * 2
    say.append("You win #{money * 2}, and the dice is #{dice}")
  else
    session[:loss] = session[:loss] + money
    user.total_loss = user.total_loss + money
    user.total_profit = user.total_profit - money
    say.append("You lost #{money}, you guess #{guess} but it's #{dice}")
  end
  session[:profit] = session[:win] - session[:loss]
  user.save

  unless session[:msg]
    session[:msg] = []
  end
  session[:msg] = say + session[:msg]

  redirect "/game?dice=#{dice}&guess=#{guess}&money=#{money}"
end

get '/' do
  erb(:blank)
end

not_found do
  erb(:notfound)
end