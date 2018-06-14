from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
import chunker

browser = webdriver.Safari()
browser.set_page_load_timeout(60)
browser.get('https://www4.bing.com/search?q=Fried%20Rice%20Recipe')

items = browser.find_element_by_class_name('items').find_elements_by_tag_name('li')
print(len(items))
count = 0
for i in items:
    ename = i.find_element_by_class_name('tit').text
    print(ename)
    if 'Fried Rice' == ename and count <= 4:
        i.find_element_by_class_name('comp_check_unchecked').click()
        count+=1
print("count is", count)
# check_boxes = browser.find_elements_by_class_name('comp_check_unchecked')
#
# for check in check_boxes[:4]:
#     check.click()

button = browser.find_element_by_id('cmp_btn')
while not browser.find_element_by_id('ent_ovlc').is_displayed():
    button.click()
    # print(browser.find_element_by_xpath('/html/body').text)

# box = browser.find_element_by_xpath('/html')
# print(box)
titles = browser.find_elements_by_class_name('ec_title cbl')
c = 0
while titles == []:
    c+=1
    titles = browser.find_elements_by_class_name('ec_title cbl')
print('c = ',c)
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
# browser.execute_script('button.click()')

# browser.mouse = webdriver.ActionChains(browser)
# elmt = browser.find_element_by_xpath("//*[@id='cmp_btn']")
# browser.mouse.move_to_element(elmt).click().perform()
# browser.close()
