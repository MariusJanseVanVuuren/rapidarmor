class Liner < ApplicationRecord
  belongs_to :company

  validates :liner_reference, uniqueness: true
  require 'csv'

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      company = Liner.create params
    end
  end

end
