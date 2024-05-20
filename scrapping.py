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

hh_soup.fi
                                                 
parsed_data = []

list_vacancies = hh_soup.find(class_='vacancy-serp-content').find_all(class_='serp-item')

# a = list_vacancies[0].select(".serp-item a.bloko-link.bloko-link_kind-secondary")

# print(a[0].text)

for hh_tag in list_vacancies:
  
  header_tag = hh_tag.find('h2', class_ = 'bloko-header-section-2')


  link_tag = hh_tag.find('a', class_ ='bloko-link')
  company = ""
  company_tag = hh_tag.find('a', class_='bloko-link bloko-link_kind-secondary')
  if company_tag is None:
    print("not found")
  else:
    print("found") 
    company = company_tag.text
  compensation_tag = header_tag.next_sibling.next_sibling.findChildren(class_="bloko-text" , recursive=True)[0]
  city_tag = hh_tag.find('span', recursive=True, class_='bloko-text',
                                attrs={'data-qa': 'vacancy-serp__vacancy-address'})
  description = hh_tag.find(class_='g-user-content')


  headers = header_tag.text.strip()
  hh_link = link_tag['href']

  
  parsed_data.append( {
      "header" : headers,
      "link" : hh_link,
      "company" : company,
      "compensation" : compensation_tag.text, 
      "city": city_tag.text, 
      "description" : description,
  })

# with open('hh.json', 'w', encoding='utf-8') as file:
#     json.dump(parsed_data, file, ensure_ascii=False, indent=4)

# if __name__ == '__main__':

print(parsed_data)
 #print(hh_tag)
 #print(vacancy_soup)