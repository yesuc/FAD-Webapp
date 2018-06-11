import scrapy
from bs4 import BeautifulSoup
import nltk, re, pprint
from nltk import word_tokenize
# from urllib import request

# NOTE: scrapy crawl MenuSpider -a urls='http://www.hamiltoneatery.com/menu'


# Takes a soup object, removes html & script & style tags & strips white space
# Returns string text of html
def process_html(soup):
    for script in soup(["script", "style","header","footer","aside","nav"]):
        script.decompose()

    text = soup.get_text()

    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    text = '\n'.join(chunk for chunk in chunks if chunk)
    return text

def process_url(url):
    print(url)
    first_dot = url.find('.')
    second_dot = url.find('.',first_dot+1)
    print(second_dot)
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
            urls = [
                'http://hamiltonroyalindiagrill.com/menu',
                'http://www.laiguanarestaurant.com/dinner/'
            ]
        else:
            tag = getattr(self, 'tag', None)
            for url in urls:
                if tag is not None:
                     url = url + '/' + tag + '/'
                yield scrapy.Request(url=url, callback=self.parse)


    def parse(self, response):
        soup = BeautifulSoup(response.text, 'lxml')
        text = process_html(soup)
        page = process_url(response.url.split("/")[2])
        filename = 'menus-%s.txt' % page
        with open(filename, 'w+') as f:
            f.write(text)
        self.log('Saved file %s' % filename)
