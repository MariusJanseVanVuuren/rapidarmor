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
        new_params["liner_reference"] = params["Liner Reference"]
        new_params["row"] = params["Row"]
        new_params["collumn"] =  params["Collumn"]
        new_params["width"] = params["Width"]
        new_params["height"] = params["Height"]
        new_params["structure"] = params["Structure"]
        new_params["plant"] = params["Plant"]
        new_params["location"] = params["Location"]
        new_params["description"] = params["DESCRIPTION"]
        if Liner.exists?(liner_reference: new_params["liner_reference"])
          liner = Liner.find_by(liner_reference: new_params["liner_reference"])
          new_params["current_thickness"] = params["Thickness"]
          original_thickness = liner.original_thickness
          new_params["thickness_loss_per_day"] = (original_thickness.to_f - new_params["current_thickness"].to_f)/(((Time.now.getutc-liner.created_at.utc)/(3600*24)).ceil).to_i
          liner.update(new_params)
        else
          new_params["original_thickness"] = params["Thickness"]
          liner = company.liners.new(new_params)
          liner.save
        end
      end
    end
  end
end
