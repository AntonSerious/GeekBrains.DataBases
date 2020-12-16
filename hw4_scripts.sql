
#1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
CREATE VIEW employees.cities_view AS
select cities.title as City, regions.title as Region, countries.title as Country
from geodata._cities cities
left join geodata._countries countries on cities.country_id = countries.id
left join geodata._regions regions on cities.region_id = regions.id;


#2. Создать функцию, которая найдет менеджера по имени и фамилии.

CREATE DEFINER=`root`@`localhost` FUNCTION `search_by_name`(last_name varchar(40), first_name varchar(40) ) RETURNS int(11)
    DETERMINISTIC
BEGIN
DECLARE result int;
SELECT d.emp_no into result
FROM employees.dept_manager d
left join employees.employees e on d.emp_no = e.emp_no
where e.last_name = last_name
and e.first_name = first_name;
RETURN result;
END
;
select search_by_name("Markovitch", "Margareta");

#3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.

DROP TRIGGER IF EXISTS `employees`.`employees_AFTER_INSERT`;
DELIMITER $$
USE `employees`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `employees`.`employees_AFTER_INSERT` AFTER INSERT ON `employees` FOR EACH ROW
BEGIN
insert into employees.salaries
set 
emp_no = NEW.emp_no, 
salary = 700, 
from_date = current_date(),
to_date = '9999-01-01';
END$$
DELIMITER ;