-- Library Management Project 
create database library_project;
use library_project;
drop table if exists branch;

-- creating branch table
create table branch(
branch_id	varchar(10) primary key,
manager_id	varchar(4),
branch_address	varchar(50),
contact_no varchar(10)
);

-- creating employee table
create table employee(
emp_id	varchar(5) primary key,
emp_name	varchar(20),
position	varchar(20),
salary	int,
branch_id varchar(10) -- fk
);

-- creating books table
create table books(
isbn varchar(20) primary key,
book_title	varchar(55),
category	varchar(20),
rental_price	float,
status	varchar(10),
author	varchar(25),
publisher varchar(25)

);

-- creating members table
create table members(
member_id	varchar(10) primary key,
member_name	varchar(20),
member_address	varchar(50),
reg_date date
);

-- creating issued table
create table issued(
issued_id varchar(10) primary key,
issued_member_id varchar(20), -- fk
issued_book_name varchar(50),
issued_date	 date,
issued_book_isbn varchar(40), -- fk
issued_emp_id varchar(20) -- fk
);

-- creating returns table
create table return_status(
return_id varchar(20) primary key,
issued_id varchar(20), -- fk
return_book_name varchar(50),	
return_date	date,
return_book_isbn varchar(15)
);

-- adding FOREIGN KEY
alter table issued
add constraint fk_members
foreign key (issued_member_id) -- issued_member_id is a primary key itself in members table
references members(member_id);

alter table issued
add constraint fk_books
foreign key (issued_book_isbn) -- issued_book_isbn is a primary key itself in books table
references books(isbn);

alter table issued
add constraint fk_employess
foreign key (issued_emp_id) -- issued_emp_id is a primary key itself in employee table
references employee(emp_id);

alter table return_status
add constraint fk_return
foreign key (issued_id) -- issued_id is a primary key itself in issued table
references issued(issued_id);

alter table employee
add constraint fk_branch
foreign key (branch_id) -- branch_id is a primary key itself in branch table
references branch(branch_id);

-- data too long for column issued_book_name from issued table so we are altering this column. we have foreign key present there so we can't drop it.
alter table issued
modify issued_book_name varchar(100);

select * from books;
select * from branch;
select * from employee;
select * from issued;
select * from members;
select * from return_status;

-- Project Task

-- 1. Create a New Book Record -- '987-1-60129-456-2', 'To Kill a Mockingbird' , 'Classic , 6.00 , 'yes', 'Harper Lee', 'J.B. Lippincot & Co.'
insert into books (isbn, book_title, category, rental_price, status, author, publisher)
values ('987-1-60129-456-2', 'To Kill a Mockingbird' , 'Classic' , 6.00 , 'yes', 'Harper Lee', 'J.B. Lippincot & Co.');
select * from books;

-- 2. Update an exixting members address where member_address = '123 Main St'
update members
set member_address = '156 Oak St'
where member_address = '123 Main St'; -- if we don't specify where then the whole member_adress will be changed
select * from members;

-- 3. Delete a Record from the issued status table where issued_id = 1S1021
delete from issued
where issued_id = 'IS1021';-- this querry run because the issued_id IS1021 doesn't exist in issued table. if this id exists in the table it will not delete because of foreign key constraint.

-- 4. select all books issued by the employee with emp_id = 'E104'
select * from issued
where issued_emp_id = 'E104';

-- 5. list the members who have issued more than 1 book
select issued_emp_id, count(issued_book_name) as no_of_issuedBooks  from issued
group by issued_emp_id
having count(issued_book_name)>1;

-- 6. Create Summary Tables: used CTAS to generate new table based on query result
-- each book and total book_issued count
create table books_counts as
select b.isbn, b.book_title, count(i.issued_id) as no_issued
from books as b
join issued as i
on b.isbn = i.issued_book_isbn
group by isbn, book_title;

-- 7. Retrieve all books with specific category
select * from books
where category = 'Classic';
 
 -- 8. find total rental income by category
 select category, sum(rental_price) as Total_rental
 from books
 group by category;
 
 -- 9. list members who registered in last 1000 days
 select * from members
 where reg_date >= current_date() - interval 1000 day;
 
 -- 10. list employee with their branch manager's name and their banch detail
select e.*, b.branch_id, em.emp_name as manager
from employee as e
join branch as b
on e.branch_id = b.branch_id
join employee as em
on b.manager_id = em.emp_id;

-- 11. create a table of books with retal_price above certail threshold $7
create table booksprice_above_7 as 
select * from books
where rental_price > 7;
select * from booksprice_above_7;

-- 12. retrieve the list of books not yet returned
select * from issued as i
left join return_status as r
on i.issued_id = r.issued_id
where r.return_id is null;