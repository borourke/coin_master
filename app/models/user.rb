class User < ActiveRecord::Base
  has_many :general_ledger
end