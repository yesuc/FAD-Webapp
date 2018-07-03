class Restaurant < ApplicationRecord
  has_many :foods

  # BUG:
  def self.query_on_constraints(constraints)
    filtered = Restaurant.all
    if constraints[:query_type] == "name"
      filtered = filtered.where("name LIKE ?", constraints[:query])
    else
      filtered = filtered.where("url LIKE ?", constraints[:query])
    end
    constraints.delete(:query)
    constraints.delete(:query_type)
    constraints.each_pair do |sym,val|
        if val == true
          if sym == :gluten
            filtered = filtered.foods.gluten_free
          elsif sym == :dairy
            filtered = filtered.foods.dairy_free
          elsif sym == :treenuts
            filtered = filtered.foods.treenuts_free
          elsif sym == :beef
            filtered = filtered.foods.beef_free
          elsif sym == :pork
            filtered = filtered.foods.pork_free
          end
        end
    end
    return filtered
  end

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
