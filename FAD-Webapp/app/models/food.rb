class Food < ApplicationRecord
  belongs_to :restaurant
  @@allergens = {
  :gluten => ['wheat', 'wheat flour','barley', 'rye', 'oats', 'malt', 'brewer’s yeast', 'triticale', 'wheatberies', 'durum', 'emmer', 'semolina', 'spelt', 'farina', 'farro', 'graham', 'einkorn wheat','pastas','raviolis','dumplings', 'couscous', 'gnocchi','noodles', 'ramen', 'udon', 'soba', 'chow mein', 'egg noodles','croissants', 'pita', 'naan', 'bagels', 'flatbreads', 'cornbread', 'potato bread', 'muffins', 'donuts', 'rolls', 'flour tortillas','cakes', 'cookies', 'pie crusts', 'brownies','cereal', 'granola', 'corn flakes', 'rice puffs','pancakes', 'waffles', 'french toast', 'crepes', 'biscuits','panko breadcrumbs', 'croutons', 'stuffings', 'dressings', 'soy sauce', 'roux','beer'],
  :dairy => ['cheddar','butter', 'butter fat', 'butter oil', 'butter acid', 'butter ester','casein hydrolysate', 'cheese', 'cottage cheese', 'cream', 'custard', 'diacetyl', 'ghee', 'half-and-half', 'lactalbumin', 'lactalbumin phosphate', 'lactoferrin', 'lactose', 'lactulose', 'milk', 'buttermilk', 'malted milk', 'goat milk','non-fat dry milk powder', 'dry milk solids','whey', 'whey protein concentrate','curds', 'casein','margarine', 'sour cream', 'tagatose', 'rennet casein', 'whey protein hydrolysate', 'sweet cream', 'yogurt', 'yoghurt','heavy cream', 'caseinates', 'nougat', 'pudding', 'sour milk solids', 'Recaldent', 'nisin'],
  :beef =>['beef', 'veal', 'wagyu beef', 'hamburger', 'hotdog', 'ribs','steak'],
  :egg=>['albumin', 'albumen', 'eggnog', 'globulin', 'livetin', 'lysozyme', 'mayonnaise', 'meringue', 'meringue powder', 'surimi', 'vitelin', 'egg', 'egg powder', 'omelette', 'ovalbumin'],
  :pork=>['pork', 'ham', 'hotdog', 'chashu pork', 'ribs'],
  :soy =>['edamame', 'miso', 'nato', 'soybean', 'shoyu', 'tamari', 'soy sauce', 'tempeh', 'soy protein','soy milk', 'tofu', 'soya', 'textured vegetable protein'],
  :peanut =>['peanuts', 'artificial nuts', 'beer nuts', 'peanut oil', 'goobers', 'ground nuts', 'mixed nuts', 'monkey nuts', 'nut pieces', 'nut meat', 'peanut butter', 'peanut flour', 'peanut protein', 'hydrolysate', 'mandelonas', 'arachis oil', 'vegetable gum', 'vegetable starch'],
  :treenuts =>['walnut', 'almond', 'hazelnut', 'cashew', 'pistachio', 'artificial nuts', 'beechnut', 'butternut', 'chestnuts', 'chinquapin', 'coconut', 'filberts', 'gianduja', 'hickory nuts', 'litchi', 'lychee', 'lichee', 'macademia nuts', 'marzipan', 'almond paste', 'Nangai nuts', 'pesto', 'pecans', 'nut pieces', 'nutmeat', 'nut meal', 'nut butter', 'natural nut extract', 'Pili nut', 'Pine nut', 'Praline', 'Shea nut', 'Walnut hull extract', 'black walnut hull', 'mortadella'],
  :shellfish => ['abalone', 'squid', 'calamari', 'snails', 'escargot', 'shrimp', 'crevette', 'scallops', 'prawns', 'oysters', 'octopus', 'mussels', 'crab', 'lobster', 'langouste', 'langoustine', 'scampo', 'coral', 'tomalley', 'cockle', 'periwinkle', 'sea urchin', 'clams', 'cherrystone', 'littleneck', 'pismo', 'quahog', 'geoduck', 'cuttlefish', 'whelk', 'limpet', 'lapas', 'opihi', 'glucosamine', 'fish stock', 'surimi'],
  :fish=>['barbecue sauce', 'bouillabaisse', 'caviar', 'Caesar salad', 'fish oil', 'fish gelatin', 'fish stock', 'fishmeal','nuoc mam ', 'roe', 'anchovy', 'Worcestershire sauce', 'sushi','sashimi', 'surimi', 'shark fin', 'shark cartilage', 'shellfish isinglass lutefisk maw', 'fish maw'],
  :sesame=>['benne', 'benne seed', 'benniseed', 'gingelly', 'gingelly oil', 'halvah', 'sesame flour', 'sesame salt', 'sesamol', 'sesamum indicum', 'sesemolina','sim sim', 'tahini','tahina', 'tehina','til','sesame seeds','sesame paste', 'sesame oil', 'falafel','goma-dofu', 'pasteli', 'tempeh'],
  :wheat=>['bread crumbs', 'bulgur', 'cereal extract', 'club wheat', 'couscous','cracker meal','durum','einkorn','emmer','farina','flour','hydrolyzed wheat protein','Kamut','matzoh','matzo', 'matzah', 'pasta', 'seitan', 'semolina', 'spelt', 'sprouted wheat', 'triticale', 'vital wheat gluten', 'bran', 'wheat germ', 'wheat grass', 'wheat malt', 'wheat sprouts', 'wheat starch', 'wheat', 'wheat flour', 'wheat germ oil', 'wheat protein isolate', 'whole wheat berries', 'glucose syrup', 'oats', 'soy sauce', 'surimi', 'starch']
  }

#PARAMS: a food item name to be queried
#RETURNS: an array as a json string
  def self.get_ingredients(food_query)
    python_output = `python /Users/priyadhawka/Desktop/FAD-Webapp/FAD-Webapp/app/controllers/webcrawler/webcrawler/spiders/bing.py #{food_query}`
    return python_output
  end

#PARAMS: a food name, description or ingredients in list form, food restriction input by User
#RETURNS: true or false depending on whether the food text contains any allergen matching food restriction
  def self.check_restrictions(food_text, restriction)
    allergen = @@allergens[restriction]
    found_allergen = food_text & allergen
    if found_allergen.empty?
      return false
    else
      return true
    end
  end

end
