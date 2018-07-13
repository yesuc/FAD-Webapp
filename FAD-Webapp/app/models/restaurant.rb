class Restaurant < ApplicationRecord
  has_many :foods

  geocoded_by :address
  after_validation :geocode, if: -> (obj){ obj.address.present? and obj.address_changed? }
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  scope :allergen_free, -> (allergen){ joins(:foods).where(foods: {"contains_#{allergen}".to_sym => false}) }
  # Given Restaurants with foods where e.g. contains gluten => false
  # ex: Restaurant.all.allergen_free("dairy")

  def self.query_on_constraints(constraints)
    # Filter by Name/URL
    if constraints[:query] == ""
      filtered = Restaurant.all
    else
      # % - indicates wildcard -- substrings
      if constraints[:query_type] == "name"
        filtered = Restaurant.where("name LIKE ?", "%#{constraints[:query]}%")
      else
        filtered = Restaurant.where("url LIKE ?", "%#{constraints[:query]}%")
      end
    end

    # Filter by Distance
    if constraints[:order] == 'distance'
      if Rails.env.development? || Rails.env.test?
        filtered = filtered.near('149.43.121.139', constraints[:query_distance], order: 'distance')
      else
        filtered = filtered.near(request.remote_ip, constraints[:query_distance], order: 'distance')
      end
    else
      if Rails.env.development? || Rails.env.test?
        filtered = filtered.near('149.43.121.139', constraints[:query_distance])
      else
        filtered = filtered.near(request.remote_ip, constraints[:query_distance])
      end
    end

    constraints.delete(:query)
    constraints.delete(:query_type)
    constraints.delete(:query_distance)

    # Filter by Allergens
    constraints.each_pair do |sym,val|
      if sym.to_s == 'order'; next; end
      if filtered.length > 0
        filtered = filtered.where(allergen_free(sym))
      end
    end

    puts("Order : #{constraints[:order]}")
    if constraints[:order] == 'name'
      filtered = filtered.reorder(constraints[:order].to_sym => :asc)
    elsif constraints[:order] == 'best_match'
      filtered = filtered.reorder(nil)
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
