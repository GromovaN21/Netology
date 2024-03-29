def calculate_salary(daily_fee):
    working_days = input('Введите число отработанных дней:')
    monthly_salary= int(working_days)*daily_fee
    print(monthly_salary)