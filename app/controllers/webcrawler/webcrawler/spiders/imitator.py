from selenium import webdriver

#   This script runs in the case that Scrapy is unable to visit a given website
#   URL in the form <...>.com/menu. This script will attempt to locate a link to
#   the menu page from the URL home page via find_menu_pdf. If found, the page
#   hosting the menu is assumed to be standard html text and so control will be
#   transfered back to Scrapy. Scrapy can also use Selenium to search for as PDF
#   , JPG, or other image or a menu if it is not in htmlself. Selenium will
#   attempt to extract the item(s) and should transfer the links and control to
#   OCR/Tika for processing.

# PARAM: String url of restaurant website homepage
# Attempts to find a Menu link using key word that match href html attributes
# RETURN: String url to perspective menu or None indicating no page found
def find_menu_page(home_url):
    # Open Chrome window - make sure to not have other windows open on same url
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size = 1200x600')
    browser = webdriver.Chrome(chrome_options=options)
    # NOTE: Experiencing "errno 54 connection reset by peer selenium." Set load time helps prevent error
    browser.set_page_load_timeout(60)
    # Key words that may indicate a link leading to menu -- ordered in most 'popular' usage
    key_words = ['Menus', 'Dining','Food', 'Dinner','Lunch', 'Sandwiches', 'Breakfast', 'Soups', 'Pastries','Take Out','Menu']
    # flag indcates whether successfully found a link using key_words
    i = 0
    followed_link = False
    browser.get(home_url)
    while not followed_link and i < len(key_words):
        try:
            link_matches = browser.find_elements_by_partial_link_text(key_words[i])
            j = 0
            while not followed_link and j < len(link_matches):
                link = link_matches[j]
                link_href = link.get_attribute('href')
                if link_href is not None and key_words[i].lower() in link_href.lower():
                    browser.get(link_href)
                    # In case request incomplete, link is not immediately returned
                    followed_link = True
                j+=1
        except:  #catch error or exception
            pass
        i+=1
    browser.quit()
    if followed_link is False:
        return None
    else:
        return link_href

# PARAM: String url of restaurant webpage hosting menu pdf
# Attempts to find link(s) to pdf formatted menu(s) on the given page using key words that match href attributes
# RETURN: A dict of menu titles mapped to string urls for perspective menus
def find_menu_pdf(url):
    # Open Chrome window - make sure to not have other windows open on same url
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size = 1200x600')
    browser = webdriver.Chrome(chrome_options=options)
    # NOTE: Experiencing "errno 54 connection reset by peer selenium." Set load time helps prevent error
    browser.set_page_load_timeout(60)
    # Key words that may indicate a link leading to menu -- ordered in most 'popular' usage
    key_words = ['Menu', 'Food', 'Dinner', 'Lunch', 'Breakfast', 'Sandwich', 'Dining']
    pdf_urls = {}
    i = 0
    followed_link = False
    browser.get(url)
    while i < len(key_words):
        try:
            link_matches = browser.find_elements_by_tag_name('a')
            j = 0
            while j < len(link_matches):
                link = link_matches[j]
                link_href = link.get_attribute('href')
                if link_href is not None and link_href != url and key_words[i].lower() in link_href.lower():
                    for key in ['pdf','download']:
                        if key in link_href and link_href not in pdf_urls:
                            pdf_urls[link.text] = link_href
                            print(link.text)
                j+=1
        except:  #catch error or exception
            pass
        i+=1
    browser.quit()
    return pdf_urls

def find_menu_image(url):
    # Open Chrome window - make sure to not have other windows open on same url
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size = 1200x600')
    browser = webdriver.Chrome(chrome_options=options)
    # NOTE: Experiencing "errno 54 connection reset by peer selenium." Set load time helps prevent error
    browser.set_page_load_timeout(60)
    key_words = ['image','jpg','png']
    img_urls = []
    i = 0
    followed_link = False
    browser.get(url)
    for tag in ['img']:
        try:
            link_matches = browser.find_elements_by_tag_name(tag)
            link_attr = None
            for link in link_matches:
                for attr in ['href','src']:
                    link_attr = link.get_attribute(attr)
                    if link_attr is not None:
                        for ext in ['jpg','png']:
                            if ext in link_attr and link_attr not in img_urls:
                                img_urls.append(link_attr)
        except:
            pass
    browser.close()
    return img_urls
