class Liner < ApplicationRecord
  belongs_to :company

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      company = Liner.create params
    end
  end

end
