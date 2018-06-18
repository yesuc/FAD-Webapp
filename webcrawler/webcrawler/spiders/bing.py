import chunker
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains

# PARAM: String of the quiered Food item e.g "Chicken Tikka Masala"
# Queries recipe of string on Bing, extracts ingredients finds common ingredients
# RETURN: String Array of common ingredients used to make query_string's food
def find_common_ingredients(query_string):
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size = 1200x600')
    browser = webdriver.Chrome(chrome_options=options)
    browser.set_page_load_timeout(60)
    browser.get('https://www4.bing.com/search?q=' + '%20'.join(query_string.split()) +'%20Recipe')

    # Finds all matching recipe comparison check boxes, checks them.
    items = browser.find_elements_by_xpath('//*[@id="ent-car-exp"]/div/div/div[2]/div/ol/*')
    # Max of 4 items can be compared at a time, must compare at least 2
    count = 0
    for i in items:
        ename = i.find_element_by_class_name('tit').text
        if query_string in ename and count < 4:
            i.find_element_by_class_name('comp_check_unchecked').click()
            count+=1
    # Find Compare Button, click it
    if count >=2:
        button = browser.find_element_by_id('cmp_btn')
        while not browser.find_element_by_id('ent_ovlc').is_displayed():
            button.click()
    # Get recipe titles
    titles = browser.find_elements_by_xpath('//*[@id="ec_facts"]/div[5]/div[1]')

    while titles == []:
        titles = browser.find_elements_by_xpath('//*[@id="ec_facts"]/div[5]/div[1]')
    ingredients_list_title = ''
    for list in titles:
        if list.text == 'Ingredients List':
            ingredients_list_title = list
    parent = ingredients_list_title.find_element_by_xpath('..')
    # Children == ingredients in list form
    children = parent.find_elements_by_class_name('ec_value')
    see_more_button = parent.find_element_by_tag_name('a')

    if see_more_button is not None: browser.execute_script("arguments[0].click();", see_more_button)

    recipe_ingredients = []
    for ingredient_list in children:
        for ingredient in ingredient_list.find_elements_by_class_name('b_paractl'):
            if ingredient.text not in recipe_ingredients:
                recipe_ingredients.append(ingredient.text)
    recipe_ingredients = chunker.parse_ingredients(recipe_ingredients)
    recipe_ingredients = chunker.clean_ingredients(recipe_ingredients)
    browser.close()
    return(recipe_ingredients)
print(find_common_ingredients('Chicken Tikka Masala'))
