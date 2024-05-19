import requests
from bs4 import BeautifulSoup
import json
import re
from tqdm import tqdm
from fake_headers import Headers


hh_web = 'https://spb.hh.ru/search/vacancy?text=python&area=1&area=2'


def get_headers():
    return Headers(browser='chrome', os='linux').generate()

hh_request = requests.get(
                hh_web, headers=get_headers(), params={'only_with_salary': True})

html_data = hh_request.text
hh_soup = BeautifulSoup(html_data)
parsed_data = []

for hh_tag in hh_soup.find_all('div', id='a11y-main-content'):
  header_tag = hh_tag.find('h2', class_ = 'bloko-header-section-2')
  link_tag = hh_tag.find ('a', class_ ='bloko-link')
  company_tag = hh_tag.find('a', class_='bloko-link bloko-link_kind-tertiary')
  compensation_tag = hh_tag.find('span', class_= 'compensation-text')
  city_tag = hh_tag.find('span', class_='vacancy-serp__vacancy-addresss')


  headers = header_tag.text.strip()
  hh_link = link_tag['href']


  parsed_data.append( {
      "header" : headers,
      "link" : hh_link,
      "company" : company_tag,
      "compensation" : compensation_tag, 
      "city": city_tag, 
  })
parsed_data


if __name__ == '__main__':

 print(company_tag)