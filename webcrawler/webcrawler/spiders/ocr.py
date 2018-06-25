import tesserocr
from tika import parser
from PIL import Image
from urllib import request

# NOTE: Tika can get a pdf from a link, Tesserocr needs a file to get an image -- t.f using urllib & Image

# PARAM: String url of menu image
# Uses Pillow to open image from url, applys tesserOCR to get raw text from image
# RETURN: String text of menu
def img_to_text(url):
    image = Image.open(request.urlopen(url))
    return tesserocr.image_to_text(image)


# PARAM: String url of menu pdf
# Uses Tika to turn menu pdf into raw text
# RETURN: String text of menu
def pdf_to_text(url):
    parsed = parser.from_file(url)
    return parsed['content'] # pdf text
