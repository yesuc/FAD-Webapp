from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
import chunker

browser = webdriver.Safari()
browser.set_page_load_timeout(60)
browser.get('https://www4.bing.com/search?q=Fried%20Rice%20Recipe')
items = browser.find_elements_by_xpath('//*[@id="ent-car-exp"]/div/div/div[2]/div/ol/*')
count = 0
for i in items:
    ename = i.find_element_by_class_name('tit').text
    if 'Fried Rice' in ename and count < 4:
        i.find_element_by_class_name('comp_check_unchecked').click()
        count+=1

if count >=2:
    button = browser.find_element_by_id('cmp_btn')
    while not browser.find_element_by_id('ent_ovlc').is_displayed():
        button.click()

titles = browser.find_elements_by_class_name('ec_title cbl')
c = 0
while titles == []:
    c+=1
    titles = browser.find_elements_by_class_name('ec_title cbl')

ingredients_list_title = ''
for list in titles:
    if list.text == 'Ingredients List':
        ingredients_list_title = list
parent = ingredients_list_title.find_element_by_xpath('..')
children = parent.find_elements_by_class_name('ec_value')
recipe_ingredients = []
for ingredient_list in children:
    for ingredient in ingredient_list.find_elements_by_class_name('b_paractl'):
        recipe_ingredients.append(ingredient.text)
chunker.parse_ingredients(recipe_ingredients)
chunker.clean_ingredients(recipe_ingredients)

# browser.close()
