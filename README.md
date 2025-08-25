# Library_Management_Project-SQL

## Project Overview

**Project Title**:  Library_Management_Project-SQL

This project is a Library Management System built entirely using SQL. It demonstrates the creation and management of a relational database for handling library operations, including branches, employees, books, members, issued books, and returns.The database schema is normalized with proper primary keys, foreign keys, and constraints to maintain data integrity.

## Objectives

1. **Set up a library management database: Design and create a relational database for managing branches, employees, members, books, and transactions.
2. **Data Integrity: Define primary keys, foreign keys, and constraints to maintain consistency and prevent invalid data.
3. **Library Operations: Implement SQL queries for adding, updating, deleting, and retrieving library records (books, members, issued and returned books).
4. **Reporting & Insights: Use SQL queries to generate reports such as most issued books, rental income by category, members with multiple issued books, and pending returns.
5. **Scalability: Provide a structured database that can be extended with advanced features like stored procedures, triggers, and views for real-world applications.

## Project Structure

## 1. Database Setup

**Database Creation**: A database named library_project is created.

**Table Creation**: Six core tables are created:
1. branch
2. employee
3. books
4. members
5. issued
6. return_status

Each table is linked using foreign key constraints to maintain referential integrity.
```sql
CREATE DATABASE library_project;

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

```
## 2. Data Exploration & Operations

**Insert Data**: Add new records to books, members, and issued.
**Update Data**: Modify member details (e.g., update addresses).
**Delete Data**: Remove issued records safely with constraints.
**Foreign Key Constraints**: Ensure issued/returned books must exist in books, and issued records must be linked to members and employees.

## 3. Data Analysis & Queries

The following SQL queries are implemented to answer specific business questions:

1. **Insert a new book record:**

```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('987-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincot & Co.');
```

2. **Update member address:**

```sql
UPDATE members
SET member_address = '156 Oak St'
WHERE member_address = '123 Main St';
```

3.**Delete an issued record:**
```sql
DELETE FROM issued
WHERE issued_id = 'IS1021';
```

4.**Books issued by a specific employee:**
```sql
SELECT * FROM issued
where issued_emp_id = 'E104';
```

5. **list the members who have issued more than 1 book**
```sql 
select issued_emp_id, count(issued_book_name) as no_of_issuedBooks  from issued
group by issued_emp_id
having count(issued_book_name)>1;
```

6. **Create Summary Tables: used CTAS to generate new table based on query result
-- each book and total book_issued count**
```sql   
create table books_counts as
select b.isbn, b.book_title, count(i.issued_id) as no_issued
from books as b
join issued as i
on b.isbn = i.issued_book_isbn
group by isbn, book_title;
```

7. **Retrieve all books with specific category**
```sql
select * from books
where category = 'Classic';
 ```
 8. **find total rental income by category**
 ```sql 
 select category, sum(rental_price) as Total_rental
 from books
 group by category;
 ```

 9. **list members who registered in last 1000 days**
 ```sql
 select * from members
 where reg_date >= current_date() - interval 1000 day;
 ```

 10. **list employee with their branch manager's name and their banch detail**
```sql 
select e.*, b.branch_id, em.emp_name as manager
from employee as e
join branch as b
on e.branch_id = b.branch_id
join employee as em
on b.manager_id = em.emp_id;
```

11. **create a table of books with retal_price above certail threshold $7**
```sql 
create table booksprice_above_7 as 
select * from books
where rental_price > 7;
select * from booksprice_above_7;
```

12. **retrieve the list of books not yet returned**
```sql 
select * from issued as i
left join return_status as r
on i.issued_id = r.issued_id
where r.return_id is null;
```
## Findings

From the queries and analysis performed on the library_project database, we observed:

1. Some members have issued multiple books, which highlights active users of the library.
2. The Classic category has notable entries such as To Kill a Mockingbird.
3. Rental prices vary, with some books exceeding $7, creating a premium list.
4. Certain employees (e.g., E104) are responsible for issuing multiple books, indicating workload distribution.
5. Some issued books remain unreturned, which can be tracked using the return_status table.
6. The database supports aggregate insights, like rental income by category and total issued counts.

## Reports

The SQL queries generated the following types of reports:

**Issued Book Report**: Which books were issued by which employee.
**Member Activity Report**: Members with multiple issued books.
**Category Report**: Rental income and number of books grouped by category.
**Overdue Report**: List of books that have not been returned.
**Branch & Employee Report**: Employees along with their branch manager’s name and details.
**Summary Tables**:
      books_counts → Tracks how often each book was issued.
      booksprice_above_7 → Identifies higher-value books.   

## Conclusion

The Library Management SQL Project successfully demonstrates:

1. How to design and implement a normalized relational database with constraints.
2. How SQL can be used not just for CRUD operations (Create, Read, Update, Delete), but also for business insights.
3. How libraries can leverage SQL queries for reporting and decision-making, such as:
      -- Tracking rental income.
      -- Monitoring unreturned books.
      -- Identifying top categories or high-demand books.
4. A strong foundation is set for future improvements, such as stored procedures, triggers, and views to automate tasks.      
