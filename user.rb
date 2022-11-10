
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

class User
  include DataMapper::Resource
  property(:id, Serial)
  property(:username, String)
  property(:password, String)
  property(:total_win, Integer)
  property(:total_loss, Integer)
  property(:total_profit, Integer)
end

DataMapper.finalize

