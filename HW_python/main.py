from application.salary import calculate_salary
from application.people import get_employees
from data.data_input import employees, d_fee
import datetime
if __name__ == '__main__':
    print(datetime.datetime.now())
    get_employees(employees)
    calculate_salary(d_fee)
	
	