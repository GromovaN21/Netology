from pprint import pprint
# читаем адресную книгу в формате CSV в список contacts_list
import csv
with open("phonebook_raw.csv", encoding="utf-8") as f:
  rows = csv.reader(f, delimiter=",")
  contacts_list = list(rows)
pprint(contacts_list)

import re
phone_list = []
phone_pattern = r'(\+7|8)\D{,2}(\d{3})\D{,3}(\d{3})\D{,2}(\d{2})\D{,2}(\d{2})\D{,10}(\d{1,6})?.*'
sub1 = r'+7(\2)-\3-\4-\5 доб. \6'
ext_pattern = r'\s*доб\.\s*$'

for contact in contacts_list:
  name = ' '.join(contact[:3]).split()
  phone = contact[5]
  phone_number = re.sub(ext_pattern, '', re.sub(phone_pattern, sub1, phone))
  phone_list += [[name[0],name[1],   contact[3], contact[4] ,  phone_number, contact[6]]]

print(phone_list)

result_phones= []
phone_dict={}
for contact in phone_list:
  key = ' '.join(contact[:2])
  if not key in phone_dict:
    phone_dict[key] = contact
    result_phones += [contact]
  existing = phone_dict.get(key)
  for i in range(2, len(contact)):
    if existing[i] == '':
      existing[i] = contact[i]

result_phones

with open('contacts.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for row in result_phones:
        writer.writerow(row)
