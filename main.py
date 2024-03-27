from application.salary import calculate_salary
from application.people import get_employees
import datetime
if __name__ == '__main__':
    print(datetime.now())
    calculate_salary(44)
    get_employees('Romanov')
        
    