class Restaurant < ApplicationRecord
  has_many :foods

  scope :allergen_free, -> (allergen){ joins(:foods).where(foods: {"contains_#{allergen}".to_sym => false}) }
  # Given Restaurants with foods where e.g. contains gluten => false
  # ex: Restaurant.all.allergen_free("dairy")


  def self.query_on_constraints(constraints)
    if constraints[:query] == ""
      filtered = Restaurant.all
    else
      if constraints[:query_type] == "name"
        filtered = Restaurant.where("name LIKE ?", constraints[:query])
      else
        filtered = Restaurant.where("url LIKE ?", constraints[:query])
      end
    end
    constraints.delete(:query)
    constraints.delete(:query_type)
    constraints.each_pair do |sym,val|
      if val == true && filtered.length > 0
        filtered = filtered.where(allergen_free(sym))
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
