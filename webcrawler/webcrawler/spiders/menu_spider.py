import scrapy
from bs4 import BeautifulSoup
import nltk, re, pprint
from nltk import word_tokenize
from . import chunker, imitator, ocr
import requests
import json

# NOTE: scrapy crawl MenuSpider -a urls='http://www.hamiltoneatery.com/'


# Takes a soup object, removes html & script & style tags & strips white space
# Returns string text of html
def process_html(soup):
    for script in soup(["script", "style","header","footer","aside","nav","noscript"]):
        script.decompose()

    text = soup.get_text()

    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    text = '\n'.join(chunk for chunk in chunks if chunk)
    return text

def process_url(url):
    first_dot = url.find('.')
    second_dot = url.find('.',first_dot+1)
    if second_dot < 0 and first_dot < 0:
        return None
    elif second_dot < 0:
        return url[:first_dot]
    else:
        return url[first_dot+1:second_dot]

class MenuSpider(scrapy.Spider):
    name = "MenuSpider"
    # NOTE: Set SEARCH_IMAGE = True to attempt to find image on menu pageself. Spider will not scrap HTML.
    SEARCH_IMAGE = False

    def start_requests(self):
        urls = [getattr(self,'urls', None)]
        if urls is None:
            raise ValueError('No URL string given')
        else:
            tag = getattr(self, 'tag', None)
            key_words = ['menu','menus','dinner','dining','food']
            for url in urls:
                # NOTE: This code is in case the given URL does not have standard url form
                # if 'com' not in url[-4:]:
                #     begin_tags_index = url.find('com')
                #     if begin_tags_index == -1:
                #         raise ValueError('Bad URL: Is not in standard Domain Name <www.xxx.com/> structure')
                #     else:
                #         url = url[:begin_tags_index+4] #Add four to begin splicing after </> in <.com/>
                followed_link = False
                new_url = ''
                i = 0
                # Attempt to visit menu containing url by attaching key_words to given url
                while not followed_link and i < len(key_words):
                    if key_words[i] not in url[-4:]:
                        new_url = url+key_words[i]
                        if requests.get(new_url).status_code == 404:
                            i+=1
                            continue
                        else:
                            followed_link = True
                        i+=1
                if followed_link:
                    yield scrapy.Request(url=new_url, callback=self.parse)
                else:
                    # Attempt to find menu url on the given webpage
                    menu_page = imitator.find_menu_page(url)
                    if menu_page is None:
                        raise ValueError('Bad url, could not find menu page')
                    else:
                        print('Initiating Imitator')
                        yield scrapy.Request(url=menu_page, callback=self.parse)

#return_items: dictionary of restaurant titles or menu titles mapped to cleaned menu text, e.g N13 -> stripped menu
#text_array: dictionary of menu titles at a specific restaurant mapped to the said menu, e.g Dessert Menu -> desserts
    def parse(self, response):
        pdf_urls = imitator.find_menu_pdf(response.url) # type = dict
        # if SEARCH_IMAGE:
        #     img_urls = imitator.find_menu_image(response.url) # type = array
        # else:
        #     img_urls = []
        text_array = {}
        return_items = {}
        # Case: Menu is in PDF form
        if len(pdf_urls) > 0:
            for title, url in pdf_urls.items():
                text = ocr.pdf_to_text(url)
                text_array[title] = text
            for key in text_array.keys():
                return_items[key] = chunker.parse_chunk(text_array[key])
                # print(return_items)
        # Case: Menu is in IMG form
        # elif SEARCH_IMAGE and len(img_urls) > 0:
        #     i = 0
        #     for url in img_urls:
        #         text = ocr.img_to_text(url)
        #         return_items[i] = chunker.parse_chunk(text)
        # Case: Menu is in HTML form
        else:
            page = process_url(response.url.split("/")[2])
            soup = BeautifulSoup(response.text, 'lxml')
            text = process_html(soup)
            return_items[page] = chunker.parse_chunk(text)
        chunker.clean_menu(return_items)
        filename = 'menu.json'
        with open(filename, 'w') as f:
            json.dump(return_items, f)
        # # print(return_items)
        return return_items
        # return return_items
