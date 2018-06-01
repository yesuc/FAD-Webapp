import nltk, re, pprint
from nltk import word_tokenize
from urllib import request
from nltk.corpus import wordnet as wn
from nltk.chunk import RegexpParser

header = '''Royal India Grill MenuIndian cuisine enjoys a great reputation among all ethnic foods in the world. It has an uncanny charm and those who try it find it rich in taste and flavor.
A common ingredient in the Indian food is a wide range of spices. The secret of Indian cuisine is in proper use of selected spices to bring out rich flavor aroma and character in food. By proper use of techniques such as roasting or frying the spices whole, or grinding them to make a paste, it is possible to draw different flavors from the same spice. The popular belief that the Indian food is generally hot, is not correct. By correct use of spices and ingredients, the food can be prepared to suit one’s taste.
Royal India Grill of Indian has prepared fresh items, paying careful attention to our patron’s choice of mind, medium or hot flavor. We do not use packaged curry powers or canned meat seafood or vegetables. Every dish at Royal India is prepared according to original which has become a part of our Indian culture over thousands of years. We are confident that your dining experience at Royal India will be a very pleasant one!
Offering a Gluten Free Menu!'''

rig = '''Shuruat/Appetizers
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

#Note: User should manually input path to Hamilton Royal Indian Grill Menu File to be read
f = open('/Users/carteryesu/Desktop/Summer Project/webcrawler/menus-hamiltonroyalindiagrill.html','r')
text = f.read()
grammar = r"""NP: {<JJ.?>*<NN.?>|<NNS.?>|<NN.?>|<NNPS.?>+ <VBN.*> <NN.*>.+}"""
# grammar = r"""
#     food: {<JJ.*>? <NN.*>+}
#     verb: {<VBN.*>}
#     """
# grammar = """CHUNK: {<JJ>} """

# Attempts to tag all words in given text, and also attempts to apply grammar parcer to filter only wanted phrases for items.
for sent in text.splitlines():
    tokens = 0
    cp = nltk.RegexpParser(grammar)
    result = cp.parse(nltk.pos_tag(nltk.word_tokenize(sent)))
    print(result)
    result.draw()
    for word, pos in nltk.pos_tag(nltk.word_tokenize(sent)):

        if (pos in ['NN','NNS','NNP','NNPS']):
            tokens+=1
    print("Nouns per Word in sentence: " + str(tokens/len(nltk.word_tokenize(sent))))
    print('\n')
f.close()
