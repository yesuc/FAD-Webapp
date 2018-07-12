import chunker
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
import sys
import json


# PARAM: String of the quiered Food item e.g "Chicken Tikka Masala"
# Queries recipe of string on Bing, extracts ingredients finds common ingredients
# RETURN: String Array of common ingredients used to make query_string's food

def find_common_ingredients(query_string_array):
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size = 1200x600')
    browser = webdriver.Chrome(chrome_options=options)
    # browser = webdriver.Safari()
    browser.set_page_load_timeout(60)
    #Split array containing food names to open only one browser window
    array = query_string_array.split(',')
    q = 0
    clean_recipe_ingredients = {}
    while q < len(array):
        query_string = array[q]
        print(query_string)
        browser.get('https://www2.bing.com/search?q=' + '%20'.join(query_string.split()) +'%20Recipe')
        ingredients = []
        #Check if bing results are in the expected layout
        try:
            i = browser.find_element_by_class_name('card')
            attr = i.find_element_by_tag_name('a').get_attribute('href')
            #Get page for first recipe from search results
            browser.get(attr)
            # Check if recipe has a 'see more' link for hidden ingredients
            try:
                table_body = browser.find_element_by_class_name('b_tblWithExpansion')
                see_more_btn = table_body.find_element_by_class_name('sml').find_element_by_tag_name('a')
                while see_more_btn.is_displayed():
                    browser.execute_script("arguments[0].click();", see_more_btn)
                if see_more_btn.is_displayed() is False:
                    table_elements = table_body.find_elements_by_tag_name('tr')
            # If no 'see more' button is found, collect ingredients from search result
            except:
                table_elements = browser.find_elements_by_tag_name('tr')
            for t in table_elements:
                ingredients.append(t.text)
            # Pass collected ingredients to chunker.py to remove extra words
            clean_recipe_ingredients[query_string] = [chunker.clean_ingredients(chunker.parse_ingredients(ingredients))]
        # If no search result is found
        except:
            clean_recipe_ingredients[query_string] = ["No search results found"]
        q+=1
    # Return ingredients for food items in a json file
    filename = 'ingredients_data.json'
    with open(filename, 'w') as f:
        json.dump(clean_recipe_ingredients, f)
    browser.close()


    # Finds all matching recipe items from bing query
    # items = browser.find_elements_by_xpath('//*[@id="ent-car-exp"]/div/div/div[2]/div/ol/*')
    # common_ingredients = {}
    # clean_recipe_ingredients = []
    # recipe_count = 0
    # count = 0
    # for i in items:
    #     # ename - name of recipe
    #     ename = i.find_element_by_class_name('tit').text
    #     # NOTE: Bing query requires at least 2 but no more than 4 compared recipes
    #     if query_string in ename and count <= 4:
    #         i.find_element_by_class_name('comp_check_unchecked').click()
    #         count+=1
    #         recipe_count+=1
    #
    #     # Find Compare Checkboxes, clicks them
    #     if count >=2:
    #         # button - compare checkbox
    #         button = browser.find_element_by_id('cmp_btn')
    #         while not browser.find_element_by_id('ent_ovlc').is_displayed():
    #             button.click()
    #         # # Get recipe titles
    #         # titles = browser.find_elements_by_xpath('//*[@id="ec_facts"]/div[5]/div[1]')
    #         # while titles == []:
    #         #     titles = browser.find_elements_by_xpath('//*[@id="ec_facts"]/div[5]/div[1]')
    #         # # # Element with Find Ingredients List text, get parent element and use parent to find ingredient lists
    #         # # ingredients_list_title = None
    #         # for list in titles:
    #         #     if list.text == 'Ingredients List':
    #         #         ingredients_list_title = list
    #         # parent = ingredients_list_title.find_element_by_xpath('..')
    #         # parent = None
    #         # while parent == None:
    #         #     parent = browser.find_element_by_xpath('//*[@id="ec_facts"]/div[6]/div[1]').find_element_by_xpath('..')
    #         # Children - ingredients in list form
    #         children = parent.find_elements_by_class_name('ec_value')
    #         # See_more element can hide ingredients; attempt to click it
    #         see_more_button = parent.find_elements_by_tag_name('a')
    #         for btn in see_more_button:
    #             if btn is not None:
    #                 # Must do execute scritp; normal get,clicks, etc do not work
    #                 browser.execute_script("arguments[0].click();", btn)
    #         recipe_ingredients = []
    #         for ingredient_list in children:
    #             for ingredient in ingredient_list.find_elements_by_class_name('b_paractl'):
    #                 recipe_ingredients.append(ingredient.text)
    #                 print(ingredient.text)
    #         clean_recipe_ingredients.append(chunker.clean_ingredients(chunker.parse_ingredients(recipe_ingredients)))
    #         close_btn = browser.find_element_by_class_name("ovlcb")
    #         close_btn.click()
    #         uncheck_all = browser.find_elements_by_class_name("comp_check_checked")
    #         for check in uncheck_all:
    #             check.click()
    #         # count = 0
    # browser.close()
    # return clean_recipe_ingredients


    # print(clean_recipe_ingredients)
    # for key in clean_recipe_ingredients:
    #     key = key.lower()
    #     if key not in common_ingredients:
    #         common_ingredients[key] = 1
    #     else:
    #         common_ingredients[key] += 1
    # final_array = []
    # print(common_ingredients)
    # for key in common_ingredients.keys():
    #     c = common_ingredients[key]
    #     print(key)
    #     if c > recipe_count/8:
    #         final_array.append(key)
    # print(final_array)
    # return json.dumps(final_array)

find_common_ingredients(sys.argv[1])
