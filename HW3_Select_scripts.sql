#База данных «Страны и города мира»:
#1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.

select cities.title as City, regions.title as Region, countries.title as Country
from geodata._cities cities
left join geodata._countries countries on cities.country_id = countries.id
left join geodata._regions regions on cities.region_id = regions.id

#2. Выбрать все города из Московской области.

select cities.title as City, regions.title as Region
from geodata._cities cities
left join geodata._regions regions on cities.region_id = regions.id
where regions.title like "Московская%"; #это плохая практика, лучше найти id интересующего региона и делать выборку по id региона

#лучше так
select cities.title as City, regions.title as Region
from geodata._cities cities
left join geodata._regions regions on cities.region_id = regions.id
where regions.id = 1053480; 

#База данных «Сотрудники»:
#1. Выбрать среднюю зарплату по отделам.

#актуальную на сегодня

SELECT depts.dept_name, avg(salaries.salary) as Average_salary
FROM employees.departments depts
left join employees.dept_emp dept_emps on depts.dept_no = dept_emps.dept_no
left join employees.salaries salaries on dept_emps.emp_no = salaries.emp_no
where current_date between dept_emps.from_date and dept_emps.to_date
and current_date between salaries.from_date and salaries.to_date
group by depts.dept_name;

#2. Выбрать максимальную зарплату у сотрудника.
#тут непонятно что искать. Скорее всего имеется в виду, вывести максимальную зарплату, которая была у сотрудника

SELECT salaries.emp_no, max(salaries.salary) as max_salary
from employees.salaries salaries
#where current_date between salaries.from_date and salaries.to_date  #думал выбрать только действующих сотрудников(неуволенных). Но понял, что у некоторых сотрудников зарплата была больше в прошлом. Переделал на более интересный вариант
group by salaries.emp_no

#вывожу максимальную зарплату всех сотрудников и период этой ЗП.
select t.*, s2.from_date, s2.to_date
from 
	(
	SELECT salaries.emp_no, max(salaries.salary) as max_salary
	from employees.salaries salaries
	group by salaries.emp_no
	) t
left join employees.salaries s2 on t.emp_no = s2.emp_no and t.max_salary = s2.salary


#3. Удалить одного сотрудника, у которого максимальная зарплата.
#Так как речь идет об удалении(а не увольнении), то тут все просто - надо просто удалить из всех баз все записи с соответствующим emp_no
#
#Если бы его надо было уволить, то в таблицах salaries, dept_emp, dept_manager, (если он явялется менеджером департамента), title нужно было бы сделать следующий update

-- update *table*
-- set *table*.to_date = current_date
-- where 
-- emp_no = (
-- 		select emp_no
--         from employees.salaries
--         where salary = (
-- 			SELECT max(salaries.salary) as max
-- 			from employees.salaries salaries
-- 			)
--         )
-- and current_date between *table*.from_date and *table*.to_date


#Немного забегая вперед:  43624 сотрудник, у которого максимальная зарплата до сих пор работает
#По сути надо удалить его из employess, 
# в таблицах salaries, dept_emp, dept_manager, (если он явялется менеджером департамента), title
# закрыть записи с этим emp_no (проставить в to_date дату удаления)

-- update *table*
-- set *table*.to_date = current_date
-- where 
-- emp_no = (
-- 		select emp_no
--         from employees.salaries
--         where salary = (
-- 			SELECT max(salaries.salary) as max
-- 			from employees.salaries salaries
-- 			)
--         )
-- and current_date between *table*.from_date and *table*.to_date

# удаляем из employyees
delete
from employees.employees
where emp_no = (
		select emp_no
        from employees.salaries
        where salary = (
			SELECT max(salaries.salary) as max
			from employees.salaries salaries
			)
        )
        


#удаляем из связей сотрудников с департаментом
delete
from employees.dept_emp
where emp_no = (
		select emp_no
        from employees.salaries
        where salary = (
			SELECT max(salaries.salary) as max
			from employees.salaries salaries
			)
        ) 
#удаляем из dept_manager
delete
from employees.dept_manager
where emp_no = (
		select emp_no
        from employees.salaries
        where salary = (
			SELECT max(salaries.salary) as max
			from employees.salaries salaries
			)
        ) 

#удаляем из title
delete
from employees.titles
where emp_no = (
		select emp_no
        from employees.salaries
        where salary = (
			SELECT max(salaries.salary) as max
			from employees.salaries salaries
			)
        ) 

#удаляем из salaries, это важно сделать именно в последний очередь, потому что из salaries мы вытаскиваем id с максимальной зп в подзапросах вышенаписанных скриптов.
# и тут появилась проблема. Синтаксис запрещает ссылаться  на таблицу из которой происходит удаление.
delete 
from employees.salaries
where emp_no = (
		select emp_no
        from employees.salaries
        where salary = (
			SELECT max(salaries.salary) as max
			from employees.salaries salaries
			)
        ) 

#В самом конце я понял, что проще всего было донастроить недостающие FK, выбрать опцию каскадное удаление 
#и просто удалить соответствующий emp_no из employees

#4. Посчитать количество сотрудников во всех отделах.
# Тут не совсем понял чем 4 задание отличается от 5. Наверно здесь нужно посчитать общее кол-во сотрудников, а в 5 задании - в разрезе отделов
#считаю только актуальных сотрудников.

SELECT count(dept_emps.emp_no) as Total_count_in_all_depts
FROM employees.departments depts
left join employees.dept_emp dept_emps on depts.dept_no = dept_emps.dept_no
where current_date between dept_emps.from_date and dept_emps.to_date

#5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

#считаю только актуальных сотрудников.

SELECT depts.dept_name, count(dept_emps.emp_no) as Total_employees_in_Dept, sum(salaries.salary) as Total_dept_salary
FROM employees.departments depts
left join employees.dept_emp dept_emps on depts.dept_no = dept_emps.dept_no
left join employees.salaries salaries on dept_emps.emp_no = salaries.emp_no
where current_date between dept_emps.from_date and dept_emps.to_date
and current_date between salaries.from_date and salaries.to_date
group by depts.dept_name;
