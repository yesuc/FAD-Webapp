import nltk, re, pprint
from nltk import word_tokenize
from urllib import request
from nltk.chunk import RegexpParser


#NOTE: Removes all description text that appears before the first instance of 'Appetizers' and the last instance of 'Menu'
# Does not negatively overwrite files which do not follow said output
def process_text(raw_text):
    new_text = re.sub('Menu.*Appetizers\n', '', raw_text, flags=re.DOTALL)
    new_text = re.sub('Dinner.*MENU','', new_text, flags=re.DOTALL)
    new_text = re.sub('Menu.*APPS','', new_text, flags=re.DOTALL)
    return new_text


#NOTE: Removes extra words such as time, date and prices from file containing menu
def iterate_menu(raw_text):
    lines = raw_text.split()
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('$',' ')
        lines[i] = ''.join(j for j in lines[i] if not j.isdigit())
        lines[i] = re.sub('\s?(?:A\.M|P\.M|a\.m|p\.m)', ' ',lines[i])
        lines[i] = re.sub('[a-z]?i+day', ' ',lines[i])
        lines[i] = ''.join(j for j in lines[i])
    raw_text = ' '.join(j for j in lines)
    return raw_text



#NOTE: User should manually input full path to Menu File to be read into files array
# Parses through file text using NLTK RegexParser and finds chunks which correspond to the specified grammar
# Parses through resulting NLTK tree and retrieves matched chunks
def parse_chunk(raw_text):
    raw_text = process_text(raw_text)
    text = iterate_menu(raw_text)
    grammar = r"""Chunk: {<JJ.?>* <NN.?>* <VB.?>* <NN.?>*}"""
    keys = chunker(grammar,text)
    return keys

measurements_dict = ["large","medium","small","cup","cups", "teaspoon","teaspoons", "tablespoon", "tablespoons", "ounce", "ounces", "pound", "pounds","pinch","pinches","cube","cubes", "bunch","bunches", "clove","cloves","ground","boneless","canned","skinless","can","cans","fresh","plain","regular", "long","centimeter","centimeters", "half","halves", "double", "inch","inches","milliliter","milimeters", "handful", "handfuls"]
def parse_ingredients(ingredients_array):
    for i in range(len(ingredients_array)):
         ingredients_array[i] = ' '.join(j for j in ingredients_array[i].split() if j.isalpha() and j not in measurements_dict)
    return ingredients_array

def clean_ingredients(ingredients_array):
        for i in range(len(ingredients_array)):
            if len(ingredients_array[i].split()) > 2: ingredients_array[i] = ' '.join(i for i in ingredients_array[i].split()[:2])
            tokens = nltk.word_tokenize(ingredients_array[i])
            for word,pos in nltk.pos_tag(tokens):
                if pos not in ['NN', 'NNS', 'JJ'] or pos in ['VBD','VB','VBG','IN','CC','RB','TO', 'PRP', 'DT', 'WRB','JJR', 'JJS']:
                    temp = ingredients_array[i].split()
                    temp.remove(word)
                    ingredients_array[i]= ' '.join(j for j in temp)
        return ingredients_array

# PARAM: Array of Strings depicting ingredients
# Tokenizes each string into word-tag pairs, applies nltk regex to filter only Adjective-Noun Strings
# RETURN: An array strings depicting basic ingredients
# def clean_ingredients2(ingredients_array):
#     clean_ingredients_array = []
#     grammar = r"""Chunk: {<JJ.?|NN.?>? <NN.?>{1,2} <VB.?>?}"""
#     for ingredient in ingredients_array:
#         ingredient = ingredient.strip().lower()
#         if len(ingredient) < 1: continue
#         # print(ingredient)
#         # chunker returns a list containing single string, must index return array to access value
#         # print (chunker(grammar,ingredient))
#         for chunk in chunker(grammar,ingredient):
#             if chunk not in clean_ingredients_array:
#                 clean_ingredients_array.append(chunk)
#             # else:
#             #     clean_ingredients_array[chunk]+=1
#     return clean_ingredients_array

# PARAM: String Regular Expression depicting Grammar to be applied to String text
# Tokenizes the given text into words-tag pairs, applies grammar nltk regex and filters words
# RETURN: Array of string words that suited the grammar regex
def chunker(grammar,text):
        cp = nltk.RegexpParser(grammar)
        result = cp.parse(nltk.pos_tag(nltk.word_tokenize(text)))
        keys = []
        for t in result:
            s = ''
            if isinstance(t,nltk.tree.Tree):
                for word in t:
                    if len(s) == 0:
                        s = word[0]
                    else:
                        s = s + ' ' + word[0]
                keys.append(s)
        return keys

def build_menu(return_items, number):
    items_array = []
    description_array = []
    menu_items = []
    values_list = list(return_items.values())
    for i in range(len(values_list[number])):
        for word,pos in nltk.tag.pos_tag(nltk.word_tokenize(values_list[number][i])):
            if word[0].isupper() and pos in ['NN', 'NNS', 'NNP'] and i not in items_array and word not in ['Crisp', 'Boneless', 'Monterey']:
                items_array.append(i)
            elif i not in description_array:
                description_array.append(i)

    for j in range(len(items_array)-1):
        index = items_array[j]
        str = ' '
        for k in range(index+1, items_array[j+1]-1):
            str+=' '
            str+= values_list[number][k]
        if len(str.strip()) == 0:
            menu_items.append([values_list[number][index], values_list[number][index+1]])
        else:
            menu_items.append([values_list[number][index],str])
    return menu_items

def clean_menu(return_items):
    keys_list = list(return_items.keys())
    for j in range(len(keys_list)):
        return_items[keys_list[j]] = build_menu(return_items,j)
    return return_items
