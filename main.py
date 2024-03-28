from application.salary import calculate_salary
from application.people import get_employees
from data import employees, daily_fee
import datetime
if __name__ == '__main__':
    print(datetime.datetime.now())
    get_employees(employees,'Romanov')
    calculate_salary(daily_fee)


        
    