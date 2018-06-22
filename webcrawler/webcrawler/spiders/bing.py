from . import chunker
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

    # Finds all matching recipe items from bing query
    items = browser.find_elements_by_xpath('//*[@id="ent-car-exp"]/div/div/div[2]/div/ol/*')
    common_ingredients = {}
    clean_recipe_ingredients = []
    recipe_count = 0
    count = 0
    for i in items:
        # ename - name of recipe
        ename = i.find_element_by_class_name('tit').text
        # NOTE: Bing query requires at least 2 but no more than 4 compared recipes
        if query_string in ename and count <= 4:
            i.find_element_by_class_name('comp_check_unchecked').click()
            count+=1
            recipe_count+=1

        # Find Compare Checkboxes, clicks them
        if count >=2:
            # button - compare checkbox
            button = browser.find_element_by_id('cmp_btn')
            while not browser.find_element_by_id('ent_ovlc').is_displayed():
                button.click()

            # Get recipe titles
            titles = browser.find_elements_by_xpath('//*[@id="ec_facts"]/div[5]/div[1]')
            while titles == []:
                titles = browser.find_elements_by_xpath('//*[@id="ec_facts"]/div[5]/div[1]')
            # Element with Find Ingredients List text, get parent element and use parent to find ingredient lists
            ingredients_list_title = ''
            for list in titles:
                if list.text == 'Ingredients List':
                    ingredients_list_title = list
            parent = ingredients_list_title.find_element_by_xpath('..')
            # Children - ingredients in list form
            children = parent.find_elements_by_class_name('ec_value')
            # See_more element can hide ingredients; attempt to click it
            see_more_button = parent.find_elements_by_tag_name('a')
            for btn in see_more_button:
                if btn is not None:
                    # Must do execute scritp; normal get,clicks, etc do not work
                    browser.execute_script("arguments[0].click();", btn)

            recipe_ingredients = []
            for ingredient_list in children:
                for ingredient in ingredient_list.find_elements_by_class_name('b_paractl'):
                    # if ingredient.text not in recipe_ingredients:
                    recipe_ingredients.append(ingredient.text)
            clean_recipe_ingredients += chunker.clean_ingredients(chunker.parse_ingredients(recipe_ingredients))
            close_btn = browser.find_element_by_class_name("ovlcb")
            close_btn.click()
            uncheck_all = browser.find_elements_by_class_name("comp_check_checked")
            for check in uncheck_all:
                check.click()
            count = 0
    browser.close()
    print()
    for key in clean_recipe_ingredients:
        key = key.lower()
        if key not in common_ingredients:
            common_ingredients[key] = 1
        else:
            common_ingredients[key] += 1
    del common_ingredients['']
    print(common_ingredients)
    print()
    final_array = []
    for key in common_ingredients.keys():
        c = common_ingredients[key]
        if c > recipe_count/4: final_array.append(key)
    return final_array
