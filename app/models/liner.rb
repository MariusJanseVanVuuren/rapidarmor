class Liner < ApplicationRecord
  belongs_to :company

  validates :liner_reference, uniqueness: true
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      company_name = params["company name"]
      company = Company.find_or_create_by name: company_name
      new_params = Hash.new
      new_params["row"] = params["row"]
      new_params["collumn"] =  params["collumn"]
      new_params["structure"] = params["structure"]
      new_params["plant"] = params["plant"]
      new_params["location"] = params["location"]
      new_params["liner_reference"] = params["liner_reference"]
      binding.pry
      liner = company.liners.new(new_params)
      liner.save
      binding.pry
    end
  end

end
