import requests
from bs4 import BeautifulSoup
import json
import re
import html
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

list_vacancies = hh_soup.find(class_='vacancy-serp-content').find_all(class_='serp-item')

for hh_tag in list_vacancies:
  
  header_tag = hh_tag.find('h2', class_ = 'bloko-header-section-2')


  link_tag = hh_tag.find('a', class_ ='bloko-link')
  company = ""
  company_tag = hh_tag.find('a', class_='bloko-link bloko-link_kind-secondary')
  if company_tag is None:
    pass
  else:
    company = company_tag.text

  compensation_tag = header_tag.next_sibling.next_sibling.findChildren(class_="bloko-text" , recursive=True)[0]
  city_tag = hh_tag.find('span', recursive=True, class_='bloko-text',
                                attrs={'data-qa': 'vacancy-serp__vacancy-address'})


  headers = header_tag.text.strip()
  hh_link = link_tag['href']
  
  vacancy_request = requests.get(  hh_link, headers=get_headers())
  vacancy_data = vacancy_request.text
  vacancy_soup = BeautifulSoup(vacancy_data)
  vacancy_description = vacancy_soup.find(class_='g-user-content')

  search_ = r'.*((D|d)jango)|.*((F|f)lask).*'
  if re.search(search_, vacancy_description.text):
     parsed_data.append( {
      "header" : headers,
      "link" : hh_link,
      "company" : company.replace('\xa0', ' '),
      "compensation" : compensation_tag.text.replace('\u2009', '').replace('\xa0', ' ').replace('\u202f', ' '), 
      "city": city_tag.text.replace('\xa0', ''), 
  })

with open('hh.json', 'w', encoding='utf-8') as file:
     json.dump(parsed_data, file, ensure_ascii=False, indent=4)


print(parsed_data)
