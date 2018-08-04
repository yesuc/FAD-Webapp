# FAD-Webapp
A Ruby on Rails web application for Food Allergens and Dietary Restrictions which began development in the Summer of 2018 at Colgate University by undergraduates Priya Dhawka '19 and Yesu Carter '19.

Integrates Python based web crawlers constructed using Python Scrapy, Selenium, Tesserocr, and NLTK modules. Currently in development, not staged for release.

# Backend Development
 * menu_spider.py - Python Scrapy file crawls to a given restaurant url, attempts to crawl to restaurant menu page by appending key words to the given url. If fails to locate menu page, calls imitator.py. Extracts Menu Data from the menu page using ocr.py or BeautifulSoup module to scrape html text. Calls chunker.py to parse menu data, extracts food name and descriptions using Python NLTK.
 * imitator.py - Python Selenium file is called by spider.py in the case that Scrapy is unable to locate a menu page. Examines home page html, searches for links associated with a menu url using keywords. Upon success, will search for Menu PDF urls or images (see SEARCH_IMAGE Variable that must be set) using keywords. Returns either menu page url or image/pdf urls.
 * ocr.py - Python file that employs Tesserocr module to extract menu text given an image url. Also employs Tika module to extract menu text from a given menu pdf url.
 * chunker.py - Python NLTK file processes menu text using NLTK chunking. Removes extraneous information like prices, returns a standardized menu food item name & description. Extracts menu item ingredients.
 * bing.py - Uses Bing Search Engine to query restaurant food items and compare ingredients with similar recipes online to determine common ingredients that are not declared in original food item description.
# App Features
  Search Bar
    *  [sdf]
