from webcrawler import *
import sys
from webcrawler.webcrawler.spiders import menu_spider
menu_spider.spiderCrawl(urls = sys.argv[1])
