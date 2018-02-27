class Company < ApplicationRecord
  has_many :liners
  has_many :users

  validates :name, uniqueness: true
  require 'csv'

  def to_s
    self.name.nil? ? "Company Name" : self.name
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      company = Company.create params
    end
  end
end
