import scrapy
from bs4 import BeautifulSoup
import nltk, re, pprint
from nltk import word_tokenize
from . import chunker, imitator, ocr
import requests

# NOTE: scrapy crawl MenuSpider -a urls='http://www.hamiltoneatery.com/menu'


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

    def start_requests(self):
        urls = [getattr(self,'urls', None)]
        if urls is None:
            raise ValueError('No URL string given')
        else:
            tag = getattr(self, 'tag', None)
            for url in urls:
                if 'menu' not in url[-4:]:
                    if requests.get(url+'menu').status_code == 404:
                        print(url)
                        yield scrapy.Request(url=imitator.find_menu_page(url), callback=self.parse)
                    else:
                        yield scrapy.Request(url=url+'menu', callback=self.parse)
                else:
                    yield scrapy.Request(url=url, callback=self.parse)



    def parse(self, response):
        pdf_urls = imitator.find_menu_pdf(response.url)
        page = process_url(response.url.split("/")[2])
        text_array = []

        if len(pdf_urls) == 0:
            soup = BeautifulSoup(response.text, 'lxml')
            text = process_html(soup)
            filename = 'menus-%s.txt' % page
            with open(filename, 'w+') as f:
                f.write(text)
            self.log('Saved file %s' % filename)
            return_items = chunker.parse_chunk(filename)

        else:
            for title, url in pdf_urls.items():
                text = ocr.pdf_to_text(url)
                title = title +'.txt'
                with open(title, 'w+') as f:
                    f.write(text)
                self.log('Saved file %s' % title)
                text_array.append(title)
            for filename in text_array:
                return_items = chunker.parse_chunk(filename)
