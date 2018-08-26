class Liner < ApplicationRecord
  belongs_to :company

  validates :liner_reference, uniqueness: true
  require 'csv'

  def self.import(file)
    if (!file.nil?)

      spreadsheet = Roo::Spreadsheet.open(file.path)
      #["Company", "Location", "Row", "Collumn", "Width", "Height", "Thickness", "Structure", "Plant", "Liner Reference", "DESCRIPTION:"]
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        params = Hash[[header, spreadsheet.row(i)].transpose]
        company_name = params["Company"]
        company = Company.find_or_create_by name: company_name

        new_params = Hash.new
        new_params["row"] = params["Row"]
        new_params["collumn"] =  params["Collumn"]
        new_params["width"] = params["Width"]
        new_params["height"] = params["Height"]
        new_params["thickness"] = params["Thickness"]
        new_params["structure"] = params["Structure"]
        new_params["plant"] = params["Plant"]
        new_params["location"] = params["Location"]
        new_params["liner_reference"] = params["Liner Reference"]
        new_params["description"] = params["DESCRIPTION"]
        liner = company.liners.new(new_params)
        liner.save
      end

      #
      # CSV.foreach(file.path, headers: true) do |row|
      #   params = row.to_hash
      #   company_name = params["company name"]
      #   company = Company.find_or_create_by name: company_name
      #   new_params = Hash.new
      #   new_params["row"] = params["row"]
      #   new_params["collumn"] =  params["collumn"]
      #   new_params["structure"] = params["structure"]
      #   new_params["plant"] = params["plant"]
      #   new_params["location"] = params["location"]
      #   new_params["liner_reference"] = params["liner reference"]
      #   liner = company.liners.new(new_params)
      #   liner.save
      # end
    end
  end

end
