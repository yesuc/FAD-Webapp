import nltk, re, pprint
from nltk import word_tokenize
from urllib import request
from nltk.corpus import wordnet as wn
from nltk.chunk import RegexpParser

#Recomendation: try applying parser (below) to test examples array
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
        lines[i] = re.sub('\s?(?:A.M|P.M|a.m|p.m)', ' ',lines[i])
        lines[i] = re.sub('[a-z]?i+day', ' ',lines[i])
        f.write(lines[i])
    f.close()

#NOTE: User should manually input full path to Menu File to be read into files array
# Parses through file text using NLTK RegexParser and finds chunks which correspond to the specified grammar
# Parses through resulting NLTK tree and retrieves matched chunks
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
