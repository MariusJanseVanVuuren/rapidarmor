class Company < ApplicationRecord
  has_many :liners
  has_many :users

  validates :name, uniqueness: true

  require 'csv'

  def to_s
    self.name.nil? ? "Company Name" : self.name
  end

  def self.import(file)
    if (!file.nil?)

      CSV.foreach(file.path, headers: true) do |row|
        spreadsheet = Roo::Spreadsheet.open(file.path)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          params = Hash[[header, spreadsheet.row(i)].transpose]
          company_name = params["Company"]
          company = Company.find_or_create_by name: company_name
        end
      end
    end
  end
end
