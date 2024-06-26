import re
from datetime import datetime, timedelta
from RPA.Browser.Selenium import Selenium
from RPA.Excel.Files import Files
from RPA.HTTP import HTTP
from RPA.Robocorp.WorkItems import WorkItems

browser = Selenium()
excel = Files()
http = HTTP()

def search_news(search_phrase, category, months):
    browser.open_available_browser('https://www.reuters.com/')
    browser.input_text('css:input.search-bar__input__ORXTq', search_phrase)
    browser.press_keys('css:input.search-bar__input__ORXTq', 'ENTER')

    browser.wait_until_page_contains_element('css:ul.search-results__list__2SxSK')
    if category:
        browser.click_element(f'link:{category}')

    news_data = Get_News_Articles()
    return news_data

def extract_news_details(article_element):
    title = article_element.find_element_by_css_selector('.basic-card_title37xHl .texttext_1FZLe').text.strip()
    date = article_element.find_element_by_css_selector('.basic-card__time__w0GMk').text.strip()
    image_url = article_element.find_element_by_css_selector('.basic-card__image__1y8qf img').get_attribute('src')

    image_filename = download_image(image_url)

    return [title, date, image_filename]

def download_image(url):
    response = http.get(url)
    if response.status_code == 200:
        image_filename = url.split('/')[-1]
        with open(f'output/{image_filename}', 'wb') as image_file:
            image_file.write(response.content)
        return image_filename
    else:
        raise ValueError(f"Failed to download image from {url}")

def Get_News_Articles():
    news_articles = []
    
    browser.wait_until_page_contains_element("css:.basic-card__container__1y8wi")
    article_elements = browser.find_elements("css:.basic-card__container__1y8wi")
    for element in article_elements:
        news_details = extract_news_details(element)
        news_articles.append(news_details)
    return news_articles