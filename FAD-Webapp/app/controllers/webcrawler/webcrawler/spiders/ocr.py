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

# print(img_to_text('https://image.zmenu.com/menupic/438004/5d2bc4a8-735b-4bf2-a2bb-4de783d45a83.jpg'))
# print(img_to_text('http://nebula.wsimg.com/16225cabe938eab1fb14fe72679831b2?AccessKeyId=4067A1CA44DD4686EEB3&disposition=0&alloworigin=1'))
