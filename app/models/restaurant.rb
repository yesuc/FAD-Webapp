class Restaurant < ApplicationRecord
  has_many :foods
  has_attached_file :image, :styles=> {:medium => "117x245>", :thumb => "20x25>" }, :default_url => "noimg.png"
  validates_attachment :image, :content_type => {:content_type => ["image/jpeg", "image/png", "image/gif"]}

  geocoded_by :address
  after_validation :geocode, if: -> (obj){ obj.address.present? and obj.address_changed? }
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  scope :allergen_free, -> (allergen){ joins(:foods).where(foods: {"contains_#{allergen}".to_sym => false}) }
  # Given Restaurants with foods where e.g. contains gluten => false
  # ex: Restaurant.all.allergen_free("dairy")

  def self.query_on_constraints(constraints)
    # filtered = Restaurant.where('false')
    # Filter by Name/URL
    if constraints[:query] == ""
      filtered = Restaurant.joins(:foods)
    else
      # % - indicates wildcard -- substrings
      filtered = Restaurant.joins(:foods)
      if constraints[:query_type] == "all"
        filtered = filtered.where("restaurants.name LIKE ? OR restaurants.url LIKE ? OR restaurants.description LIKE ? OR restaurants.cuisine LIKE ?", "%#{constraints[:query]}%","%#{constraints[:query]}%",  "%#{constraints[:query]}%", "%#{constraints[:query]}").distinct
        if filtered == []
          filtered = Restaurant.joins(:foods).where("foods.name LIKE ? OR foods.ingredients LIKE ? OR foods.description LIKE ?", "%#{constraints[:query]}%","%#{constraints[:query]}%",  "%#{constraints[:query]}%" ).distinct
        else
          filtered.or(filtered.where("foods.name LIKE ? OR foods.ingredients LIKE ? OR foods.description LIKE ?", "%#{constraints[:query]}%","%#{constraints[:query]}%",  "%#{constraints[:query]}%" )).distinct
        end
      elsif constraints[:query_type] == "name"
        filtered = Restaurant.where("restaurants.name LIKE ?", "%#{constraints[:query]}%")
      else
        filtered = Restaurant.where("restaurants.url LIKE ?", "%#{constraints[:query]}%")
      end
    end

    # Filter by Distance
    if constraints[:order] == 'distance'
      if constraints[:query_distance] != "0"
        if Rails.env.development? || Rails.env.test?
          filtered = filtered.near('149.43.121.139', constraints[:query_distance], order: 'distance')
        else
          filtered = filtered.near(request.remote_ip, constraints[:query_distance], order: 'distance')
        end
      end
    else
      if constraints[:query_distance] != "0"
        if Rails.env.development? || Rails.env.test?
          filtered = filtered.near('149.43.121.139', constraints[:query_distance])
        else
          filtered = filtered.near(request.remote_ip, constraints[:query_distance])
        end
      end
    end
    constraints.delete(:query)
    constraints.delete(:query_type)
    constraints.delete(:query_distance)

    # Filter by Allergens
    constraints.each_pair do |sym,val|
      if sym.to_s == 'order'; next; end
      filtered = filtered.where(foods: {"contains_#{sym.to_s}".to_sym => false})
    end
    filtered = filtered.distinct
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
