class Interlink < ApplicationRecord
  def self.import(file)
    CSV.foreach(file.path,headers: true) do |row|
      Interlink.find_or_create_by(row.to_hash)
    end
  end
end
