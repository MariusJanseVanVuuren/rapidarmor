class User < ApplicationRecord
  belongs_to :company

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      params = row.to_hash
      company = User.create params
    end
  end

end
