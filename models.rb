require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    has_many :tasks
    validates :name, uniqueness: true
end

class Task < ActiveRecord::Base
    belongs_to :user
end