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

end
