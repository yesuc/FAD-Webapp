import nltk, re, pprint
from nltk import word_tokenize
from urllib import request
from nltk.chunk import RegexpParser


#NOTE: Removes all description text that appears before the first instance of 'Appetizers' and the last instance of 'Menu'
# Does not negatively overwrite files which do not follow said output
def process_text(filename):
    with open(filename, 'r') as org_file:
        original_text = org_file.read()
    new_text = re.sub('Menu.*Appetizers\n', '', original_text, flags=re.DOTALL)
    with open(filename, 'w') as new_file:
        new_file.write(new_text)

#NOTE: Removes extra words such as time, date and prices from file containing menu
def iterate_menu(filename):
    f= open(filename)
    lines = f.readlines()
    f.close()
    f = open(filename,"w+")
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('$',' ')
        lines[i] = ''.join(j for j in lines[i] if not j.isdigit())
        lines[i] = re.sub('\s?(?:A\.M|P\.M|a\.m|p\.m)', ' ',lines[i])
        lines[i] = re.sub('[a-z]?i+day', ' ',lines[i])
        f.write(lines[i])
    f.close()

#NOTE: User should manually input full path to Menu File to be read into files array
# Parses through file text using NLTK RegexParser and finds chunks which correspond to the specified grammar
# Parses through resulting NLTK tree and retrieves matched chunks
def parse_chunk(filename):
    process_text(filename)
    iterate_menu(filename)
    f = open(filename,'r')
    text = f.read()
    grammar = r"""Chunk: {<JJ.?>* <NN.?>* <VB.?>* <NN.?>*}"""
    keys = chunker(grammar,text)
    f.close()
    return keys

measurements_dict = ["large","medium","small","cup", "teaspoon", "tablespoon", "ounces", "cups", "teaspoons","tablespoons","pound","pounds","dashes","pinch","cubes", "bunch", "ounce", "cloves","ground","boneless","canned","skinless","can","fresh","plain","regular", "long","centimeters", "half", "double", "inch","milliliters", "handful"]
def parse_ingredients(ingredients_array):
    for i in range(len(ingredients_array)):
        ingredients_array[i] = ' '.join(j for j in ingredients_array[i].split() if j.isalpha() and j not in measurements_dict)
        # ingredients_array[i] = ' '.join(k for k in ingredients_array[i].split() if k not in ["large","medium","small","cup", "teaspoon", "tablespoon", "ounces", "cups", "teaspoons","tablespoons","pound","pounds","dashes","pinch","cubes", "bunch", "ounce", "cloves"])
        # ingredients_array[i] = ' '.join(k for k in ingredients_array[i].split() if k not in ["ground","boneless","canned","skinless","can","fresh","plain","regular", "long"])
        # ingredients_array[i] = ' '.join(k for k in ingredients_array[i].split() if k not in ["centimeters", "half", "double", "inch","milliliters", "handful"])
    return ingredients_array


def clean_ingredients(ingredients_array):
        for i in range(len(ingredients_array)):
            if len(ingredients_array[i].split()) > 2: ingredients_array[i] = ' '.join(i for i in ingredients_array[i].split()[:2])
            tokens = nltk.word_tokenize(ingredients_array[i])
            for word,pos in nltk.pos_tag(tokens):
                if pos not in ['NN', 'NNS', 'JJ'] or pos in ['VBD','VB','VBG','IN','CC','RB','TO', 'PRP', 'DT', 'WRB','JJR', 'JJS']:
                # if pos == 'VBD' or pos == 'VB' or pos == 'IN' or pos == 'CC' or pos == 'RB' or pos == 'TO' or pos == "JJ":
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
