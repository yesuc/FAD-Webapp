class Food < ApplicationRecord
  belongs_to :restaurant, optional: true
  # Optional required to be set to true (is automatically false) under rails 5, otherwise parent object is invalid

  @@allergens = {
  :gluten => ['buns','bread','wheat', 'wheat flour','barley', 'rye', 'oats', 'malt', 'brewer’s yeast', 'triticale', 'wheatberies', 'durum', 'emmer', 'semolina', 'spelt', 'farina', 'farro', 'graham', 'einkorn wheat','pastas','raviolis','dumplings', 'couscous', 'gnocchi','noodles', 'ramen', 'udon', 'soba', 'chow mein', 'egg noodles','croissants', 'pita', 'naan', 'bagels', 'flatbreads', 'cornbread', 'potato bread', 'muffins', 'donuts', 'rolls', 'flour tortillas','cakes', 'cookies', 'pie crusts', 'brownies','cereal', 'granola', 'corn flakes', 'rice puffs','pancakes', 'waffles', 'french toast', 'crepes', 'biscuits','panko breadcrumbs', 'croutons', 'stuffings', 'dressings', 'soy sauce', 'roux','beer', 'flour', 'naan'],
  :dairy => ['curd', 'curd dahi','cheddar','butter', 'butter fat', 'butter oil', 'butter acid', 'butter ester','casein hydrolysate', 'cheese', 'cottage cheese', 'cream', 'custard', 'diacetyl', 'ghee', 'half-and-half', 'lactalbumin', 'lactalbumin phosphate', 'lactoferrin', 'lactose', 'lactulose', 'milk', 'buttermilk', 'malted milk', 'goat milk','non-fat dry milk powder', 'dry milk solids','whey', 'whey protein concentrate','curds', 'casein','margarine', 'sour cream', 'tagatose', 'rennet casein', 'whey protein hydrolysate', 'sweet cream', 'yogurt', 'yoghurt','heavy cream', 'caseinates', 'nougat', 'pudding', 'sour milk solids', 'Recaldent', 'nisin', 'paneer', 'curd'],
  :beef =>['beef', 'veal', 'wagyu beef', 'hamburger', 'hotdog', 'ribs','steak'],
  :egg=>['albumin', 'albumen', 'eggnog', 'globulin', 'livetin', 'lysozyme', 'mayonnaise', 'meringue', 'meringue powder', 'surimi', 'vitelin', 'egg', 'egg powder', 'omelette', 'ovalbumin','eggs'],
  :pork=>['pork', 'ham', 'hotdog', 'chashu pork', 'ribs'],
  :soy =>['edamame', 'miso', 'nato', 'soybean', 'shoyu', 'tamari', 'soy sauce', 'tempeh', 'soy protein','soy milk', 'tofu', 'soya', 'textured vegetable protein', 'soy'],
  :peanut =>['peanuts', 'artificial nuts', 'beer nuts', 'peanut oil', 'goobers', 'ground nuts', 'mixed nuts', 'monkey nuts', 'nut pieces', 'nut meat', 'peanut butter', 'peanut flour', 'peanut protein', 'hydrolysate', 'mandelonas', 'arachis oil', 'vegetable gum', 'vegetable starch'],
  :treenuts =>['walnut', 'almond', 'hazelnut', 'cashew', 'pistachio', 'artificial nuts', 'beechnut', 'butternut', 'chestnuts', 'chinquapin', 'coconut', 'filberts', 'gianduja', 'hickory nuts', 'litchi', 'lychee', 'lichee', 'macademia nuts', 'marzipan', 'almond paste', 'Nangai nuts', 'pesto', 'pecans', 'nut pieces', 'nutmeat', 'nut meal', 'nut butter', 'natural nut extract', 'Pili nut', 'Pine nut', 'Praline', 'Shea nut', 'Walnut hull extract', 'black walnut hull', 'mortadella'],
  :shellfish => ['abalone', 'squid', 'calamari', 'snails', 'escargot', 'shrimp', 'crevette', 'scallops', 'prawns', 'oysters', 'octopus', 'mussels', 'crab', 'lobster', 'langouste', 'langoustine', 'scampo', 'coral', 'tomalley', 'cockle', 'periwinkle', 'sea urchin', 'clams', 'cherrystone', 'littleneck', 'pismo', 'quahog', 'geoduck', 'cuttlefish', 'whelk', 'limpet', 'lapas', 'opihi', 'glucosamine', 'fish stock', 'surimi'],
  :fish=>['fish','barbecue sauce', 'bouillabaisse', 'caviar', 'Caesar salad', 'fish oil', 'fish gelatin', 'fish stock', 'fishmeal','nuoc mam ', 'roe', 'anchovy', 'Worcestershire sauce', 'sushi','sashimi', 'surimi', 'shark fin', 'shark cartilage', 'shellfish isinglass lutefisk maw', 'fish maw'],
  :sesame=>['benne', 'benne seed', 'benniseed', 'gingelly', 'gingelly oil', 'halvah', 'sesame flour', 'sesame salt', 'sesamol', 'sesamum indicum', 'sesemolina','sim sim', 'tahini','tahina', 'tehina','til','sesame seeds','sesame paste', 'sesame oil', 'falafel','goma-dofu', 'pasteli', 'tempeh'],
  :wheat=>['bread','bread crumbs', 'bulgur', 'cereal extract', 'club wheat', 'couscous','cracker meal','durum','einkorn','emmer','farina','flour','hydrolyzed wheat protein','Kamut','matzoh','matzo', 'matzah', 'pasta', 'seitan', 'semolina', 'spelt', 'sprouted wheat', 'triticale', 'vital wheat gluten', 'bran', 'wheat germ', 'wheat grass', 'wheat malt', 'wheat sprouts', 'wheat starch', 'wheat', 'wheat flour', 'wheat germ oil', 'wheat protein isolate', 'whole wheat berries', 'glucose syrup', 'oats', 'soy sauce', 'surimi', 'starch', 'bread']
  }

  scope :gluten_free, -> { where contains_gluten: false }
  scope :dairy_free, -> { where contains_dairy: false}
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


  def self.check_restrictions(food_text, restriction)
    allergen = @@allergens[restriction]
    found_allergen = food_text & allergen
    if found_allergen.empty?
      return false
    else
      return true
    end
  end

  def self.generate_tags
    tags = []
    Food.column_names.each do |name|
      # e.g. contains_gluten
      if name =~ /^contains/
        tags << name[name.index('_')+1..-1]
      end
    end
    return tags
  end

  def self.get_allergen_Acr(f)
    allergens = []
    f.attributes.each do |tag,val|
      if tag =~ /^contains/
        if val == false
          allergens << tag[tag.index('_')+1..-1].capitalize + " Free"
        end
      end
    end
    return allergens
  end

end
