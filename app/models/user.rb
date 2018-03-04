class User < ApplicationRecord
  belongs_to :company

  validates :email, uniqueness: true
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      user = User.create params
    end
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.password_digest == submitted_password
  end

  def authenticate(submitted_password)
    self.password_digest == submitted_password
  end
end
