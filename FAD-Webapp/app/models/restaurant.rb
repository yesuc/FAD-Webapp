class Restaurant < ApplicationRecord
  has_many :foods

  def self.filter_on_constraints(constraints)
    filtered = Restaurant.all

    constraints.each_pair do |sym,val|
      if sym == :name
        filtered = filtered.where("name LIKE ?", val)
      elsif sym == :url
        filtered = filtered.where("url LIKE ?", val)
      elsif sym == :address
        filtered = filtered.where("address LIKE ?", val)
      elsif sym == :cuisine
        filtered = filtered.where("cuisine LIKE ?", val)
      end
    end
    return filtered
  end
end
