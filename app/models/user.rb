class User < ApplicationRecord
  belongs_to :company
  has_secure_password

  validates :email, uniqueness: true
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash

      company_name = params["company name"]
      company = Company.find_or_create_by name: company_name

      new_params = Hash.new
      new_params["name"] = params["name"]
      new_params["email"] =  params["email"]
      new_params["password"] = params["password"]

      user = company.users.new(new_params)
      user.save
    end
  end
end
