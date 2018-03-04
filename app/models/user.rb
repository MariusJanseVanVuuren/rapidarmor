class User < ApplicationRecord
  belongs_to :company
  has_secure_password
  validates :email, uniqueness: true
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      user = User.create params
    end
  end
end
