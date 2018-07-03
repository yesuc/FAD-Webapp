class Food < ApplicationRecord
  belongs_to :restaurant, optional: true
  # Optional required to be set to true (is automatically false) under rails 5, otherwise parent object is invalid


  scope :gluten_free, -> { where contains_gluten: false }
  scope :dairy_free, -> { where contains_dairy: false }
  scope :treenuts_free, -> { where contains_treenuts: false }
  scope :beef_free, -> { where contains_beef: false }
  scope :pork_free, -> { where contains_beef: false }
  scope :soy_free, -> { where contains_soy: false }
  scope :egg_free, -> { where contains_egg: false }
  scope :shellfish_free, -> { where contains_shellfish: false }
  scope :peanut_free, -> { where contains_peanut: false }
  scope :fish_free, -> { where contains_fish: false }
  scope :sesame_free, -> { where contains_sesame: false }
  scope :wheat_free, -> { where contains_wheat: false}

  def self.get_ingredients(food_query)
    python_script = `python /Users/priyadhawka/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/webcrawler/webcrawler/spiders/bing.py #{food_query.name}`
    file = File.read('ingredients_data.json')
    ingredients_hash = JSON.parse(file)
    food_query.ingredients = ingredients_hash
  end


  def self.check_restrictions(food, restriction)
    food_name = food.name.split()
    food_description = food.description.split()
    food_ingredients = food.ingredients.split()
    allergen = @@allergens[restriction]
    contains = "contains_"+ restriction.to_s

    food_name.each do |f|
      if allergen.include?(f)
        food[contains.to_sym] = true
      end
    end
    food_description.each do |f|
      if allergen.include?(f)
        food[contains.to_sym] = true
      end
    end
    food_ingredients.each do |f|
      if allergen.include?(f)
        food[contains.to_sym]  = true
      end
    end
  end


end
