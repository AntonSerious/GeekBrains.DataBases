1. Реализовать практические задания на примере других таблиц и запросов.

Приложил 2 скрина
2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.

Классический пример с переводом денег от одного пользователя к другому.

Для первого пользователя необходимо уменьшить его баланс на 100 рублей, а для второго пользователя необходимо увеличить его баланс на 100 рублей. 
При чем пользователи могут находится вообще в разных таблицах, которые никак друг с другом не связаны. А апдейты надо произвести "одновременно", либо не проивзести совсем.
Пример:

start transaction
update users
set balance = balance - 100
where user_id = 1

update users
set balance = balance + 100
where user_id = 2
commit;
3. Проанализировать несколько запросов с помощью EXPLAIN.
;

explain
SELECT depts.dept_name, count(dept_emps.emp_no) as Total_employees_in_Dept, sum(salaries.salary) as Total_dept_salary
FROM employees.departments depts
left join employees.dept_emp dept_emps on depts.dept_no = dept_emps.dept_no
left join employees.salaries salaries on dept_emps.emp_no = salaries.emp_no
where current_date between dept_emps.from_date and dept_emps.to_date
and current_date between salaries.from_date and salaries.to_date
group by depts.dept_name;

#попытка опитмизации

#сделал группировку по dept_no, а не по dept_name
#и переписал условие where, но результатов это особо не дало.
explain
SELECT depts.dept_name, count(dept_emps.emp_no) as Total_employees_in_Dept, sum(salaries.salary) as Total_dept_salary
FROM employees.departments depts
inner join employees.dept_emp dept_emps on depts.dept_no = dept_emps.dept_no
left join employees.salaries salaries on dept_emps.emp_no = salaries.emp_no
where dept_emps.to_date = '9999-01-01'
and salaries.to_date = '9999-01-01'
group by depts.dept_no;