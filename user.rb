
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")

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

