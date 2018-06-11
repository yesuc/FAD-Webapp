import tesserocr
from tika import parser
import urllib, io

# NOTE: Tika can get a pdf from a link, Tesserocr needs a file to get an image -- t.f using urllib & StringIO

# PARAM: String url of menu image
# Uses OCR to turn menu image from URL into raw text
# RETURN: String text of menu
def img_to_text(url):
    file = io.StringIO(urllib.urlopen(url).read())
    text = tesserocr.file_to_text(file)
    filename = 'colgate.txt'
    with open(filename, 'w+') as f:
        f.write(text)
    return text

# PARAM: String url of menu pdf
# Uses Tika to turn menu pdf into raw text
# RETURN: String text of menu
def pdf_to_text(url):
    parsed = parser.from_file(url)
    return parsed['content'] # pdf text
