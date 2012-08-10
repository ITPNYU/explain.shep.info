require 'bcrypt'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/dev.sqlite")

class Email
  include DataMapper::Resource

  property :id, Serial, key:true

  # Email content
  property :message_id, String, unique: true
  property :from, String
  property :subject, String
  property :date, DateTime
  property :body, Text

  # PleaseExplain Data
  property :approved, Boolean
  property :approved_by, Integer # user.id
  property :sent, Boolean, default: false
end

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, key: true
  property :email, String
  property :password_hash, BCryptHash
  property :token, String

  property :created_at, DateTime
  property :updated_at, DateTime

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!