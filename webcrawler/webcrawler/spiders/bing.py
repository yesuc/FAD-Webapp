from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
browser = webdriver.Safari()
browser.set_page_load_timeout(60)
browser.get('https://www4.bing.com/search?q=Fried%20Rice%20Food')
check_boxes = browser.find_elements_by_class_name('comp_check_unchecked')
for check in check_boxes[:4]:
    check.click()
button = browser.find_element_by_id('cmp_btn')
for i in range(15):
    button.click()
# browser.execute_script('button.click()')

# browser.mouse = webdriver.ActionChains(browser)
# elmt = browser.find_element_by_xpath("//*[@id='cmp_btn']")
# browser.mouse.move_to_element(elmt).click().perform()
# browser.close()
