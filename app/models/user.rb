class User < ApplicationRecord
  belongs_to :company

  validates :email, uniqueness: true
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      company = User.create params
    end
  end

end
