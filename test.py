import nltk, re, pprint
from nltk import word_tokenize
from urllib import request
from nltk.corpus import wordnet as wn
from nltk.chunk import RegexpParser

header = '''Royal India Grill MenuIndian cuisine enjoys a great reputation among all ethnic foods in the world. It has an uncanny charm and those who try it find it rich in taste and flavor.
A common ingredient in the Indian food is a wide range of spices. The secret of Indian cuisine is in proper use of selected spices to bring out rich flavor aroma and character in food. By proper use of techniques such as roasting or frying the spices whole, or grinding them to make a paste, it is possible to draw different flavors from the same spice. The popular belief that the Indian food is generally hot, is not correct. By correct use of spices and ingredients, the food can be prepared to suit one’s taste.
Royal India Grill of Indian has prepared fresh items, paying careful attention to our patron’s choice of mind, medium or hot flavor. We do not use packaged curry powers or canned meat seafood or vegetables. Every dish at Royal India is prepared according to original which has become a part of our Indian culture over thousands of years. We are confident that your dining experience at Royal India will be a very pleasant one!
Offering a Gluten Free Menu!'''

item = '''Shuruat/Appetizers
Veg Pakora
3.95
Fresh vegetable dipped in spices batter and fried to golden perfection.'''


iguana = '''POACHED SHRIMP $9.00
Shrimp poached in garlic butter and black pepper. Served with grilled flour tortillas .''','''Dinner | La Iguana
10 Broad Street, Hamilton, NY 13346 315-824-0022
Home
Menus
Dinner
Children
Take Out
Jobs
Gallery
Contact
Select Page'''

test = [header, item, iguana]

#Recomendation: try applying parser (below) to test examples array
#NOTE: Removes all description text that appears before the first instance of 'Appetizers' and the last instance of 'Menu'
# Does not negatively overwrite files which do not follow said output
def process_text(filename):
    with open(filename, 'r') as org_file:
        original_text = org_file.read()
    new_text = re.sub('Menu.*Appetizers\n', '', original_text, flags=re.DOTALL)
    with open(filename, 'w') as new_file:
        new_file.write(new_text)
        
#NOTE: Removes extra 'buzzwords such as time, date' and prices from file containing menu
def iterate_menu(filename):
    f= open(filename)
    lines = f.readlines()
    f.close()
    f = open(filename,"w+")
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('$',' ')
        lines[i] = ''.join(j for j in lines[i] if not j.isdigit())
        lines[i] = re.sub('\s?(?:A.M|P.M|a.m|p.m)', ' ',lines[i])
        lines[i] = re.sub('[a-z]?i+day', ' ',lines[i])
        f.write(lines[i])
    f.close()

#Note: User should manually input path to Menu File to be read
files = ['/Users/priyadhawka/Desktop/rigtester/menu-www.laiguanarestaurant.com.txt','/Users/priyadhawka/Desktop/rigtester/menu-www.noodles13.com.txt', '/Users/priyadhawka/Desktop/rigtester/menu-hamiltonroyalindiagrill.com.txt']
filename = files[2]
process_text(filename)
iterate_menu(filename)
f = open(filename,'r')
text = f.read()
grammar = r"""Chunk: {<JJ.?>* <NN.?>* <VB.?>* <NN.?>*}"""
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
f.close()
