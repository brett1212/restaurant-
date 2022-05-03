-- Drop Tables
Drop Table Ingredients CASCADE CONSTRAINTS;
Drop Sequence ingredient_id_seq;
Drop Table Customers CASCADE CONSTRAINTS;
Drop Sequence  customer_id_seq;
Drop Table Orders CASCADE CONSTRAINTS;
Drop Sequence order_id_seq;
Drop Table Suppliers CASCADE CONSTRAINTS;
Drop Sequence supplier_id_seq;
Drop Table Departments CASCADE CONSTRAINTS;
Drop Sequence department_id_seq;
Drop Table jobs CASCADE CONSTRAINTS;
Drop Sequence job_id_seq;
Drop Table Employees CASCADE CONSTRAINTS;
Drop Sequence employee_id_seq;
Drop Table Recipes CASCADE CONSTRAINTS;
Drop Sequence recipe_id_seq;
Drop Table Ing_items CASCADE CONSTRAINTS;
Drop Sequence ing_item_id_seq;
Drop Table Job_history CASCADE CONSTRAINTS;
Drop Sequence job_history_id_seq;
Drop Table Order_items CASCADE CONSTRAINTS;
Drop Sequence order_item_id_seq;
Drop Table Chef_orders CASCADE CONSTRAINTS;
Drop Sequence chef_order_id_seq;
Drop Table Supplier_lists CASCADE CONSTRAINTS;
Drop SEQUENCE supplier_list_id_seq;
Drop Table VIPS CASCADE CONSTRAINTS;


-- All Sequences
CREATE SEQUENCE ingredient_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE order_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE customer_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE; 

    CREATE SEQUENCE supplier_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE; 

    CREATE SEQUENCE department_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE; 

    CREATE SEQUENCE job_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE recipe_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE employee_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE job_history_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE ing_item_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE order_item_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE chef_order_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

    CREATE SEQUENCE supplier_list_id_seq
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;


-- All Create Tables

-- INgredients Tables
CREATE TABLE Ingredients (
    ingredient_id number(10) CONSTRAINT ingredients_ingredient_id_pk PRIMARY KEY,
    ingredient_name varchar (50),
    stock number(10,2),
    unit varchar (10)

);

-- Cusomters Table
Create Table Customers(
    Customer_id number(10) Constraint customers_customer_id_pk Primary Key,
    Fname varchar(50),
    Lname varchar(50),
    Phone_num varchar(50)
);

-- VIP Table
create table vips(
    customer_id number(10) CONSTRAINT vips_customer_id_fk REFERENCES customers(customer_id),
    start_date DATE,
    vip_period INTERVAL DAY(2) TO SECOND,
    CONSTRAINT VIP_COMP_KEY PRIMARY KEY (customer_id, start_date) 
    );

-- Orders Table
 CREATE TABLE Orders(
    order_id number(10) CONSTRAINT orders_order_id_pk PRIMARY KEY,
    order_date date,
    customer_id number(10) Constraint orders_customer_id_pk References Customers(customer_id),
    employee_id number(10)

);

-- Suppliers Table
CREATE TABLE Suppliers (
    supplier_id number(10) CONSTRAINT suppliers_supplier_id_pk PRIMARY KEY,
    supplier_name varchar (50),
    supplier_location varchar (50),
    phone_num varchar (10)

);

-- Departments Table
CREATE TABLE Departments(
    department_id number(10) CONSTRAINT departments_department_id_pk PRIMARY KEY,
    department_name varchar (50)
);

-- Jobs Table
CREATE TABLE Jobs(
    job_id number(10) CONSTRAINT jobs_job_id_pk PRIMARY KEY,
    job_title varchar (50),
    min_salary number(10),
    max_salary number(10)
);

-- Recipes Table
 Create Table recipes(
        Recipe_id number(10) Constraint recipes_recipe_id_pk Primary Key,
        Recipe_name varchar(50),
        Recipe_serving number(5),
        Recipe_cost decimal(10,2),
        RECIPE_SELLING_PRICE decimal(10,2),
        Recipe_profitmultiplier decimal(10,2)
    );

-- Employees Table
CREATE TABLE Employees (
    employee_id number(10) CONSTRAINT employees_employee_id_pk PRIMARY KEY,
    manager_id number(10),
    fname varchar (50),
    lname varchar (50),
    phone_num varchar(10),
    hire_date DATE,
    salary number(10),
    department_id number(10) CONSTRAINT employees_department_id_fk REFERENCES departments(department_id),
    job_id number(10) CONSTRAINT employees_job_id_fk REFERENCES jobs(job_id)
   

);
   
-- Jobs History Table
CREATE TABLE Job_History(
    job_history_id number(10) CONSTRAINT job_history_job_history_id_pk PRIMARY KEY,
    start_date date,
    end_date date,
    employee_id number(10) CONSTRAINT job_history_employee_id_fk REFERENCES employees(employee_id),
    department_id number(10) CONSTRAINT job_history_department_id_fk REFERENCES departments(department_id),
    job_id number(10) CONSTRAINT job_history_job_id_fk REFERENCES jobs(job_id)
);

-- INgredient Items Table
Create Table ing_items(
        Ing_item_id number(10) Constraint ing_items_Ing_item_id_pk Primary Key,
        Amount number(10,2),
        Ingredient_id number(10) CONSTRAINT ing_items_ingredient_id_pk References Ingredients(ingredient_id),
        Recipe_id number(10) Constraint ing_items_Recipe_id_pk References Recipes(Recipe_id)
    );

-- Order Items Table
CREATE TABLE Order_items(
    order_item_id number(10) CONSTRAINT orders_item_order_id_pk PRIMARY KEY,
    order_item_star_rating number(2),
    order_itemcost number(8,2),
    order_id number(10) Constraint order_items_order_id_pk References orders(order_id), 
    Recipe_id number(10) Constraint order_items_Recipe_id_pk References Recipes(Recipe_id)
);

-- Chef Orders Table
Create Table chef_orders(
    chef_order_id number(10)  CONSTRAINT chef_orders_chef_order_id_pk PRIMARY KEY,
    employee_id number(10) CONSTRAINT  chef_orders_employee_id_fk REFERENCES Employees(employee_id),
    Order_item_id number (10) Constraint  chef_orders_order_item_id_fk References Order_items(Order_item_id),
    Order_starttime timestamp, -- default current_timestamp not null,
    Order_endtime timestamp -- default current_timestamp not null
);

-- Suppilers Lists Table
Create Table Supplier_Lists(
    Supplier_list_id number(10) Constraint supplier_lists_supplier_list_id_pk Primary Key,
    Supplier_id number(10) Constraint supplier_lists_supplier_id_fk References Suppliers(supplier_id),
    Ingredient_id number(10) Constraint supplier_lists_ingredient_id_fk References Ingredients(ingredient_id),
    price decimal(10,2),
    amount number(10)
);

-- Kitchen Staff View
Create Or Replace view Kitchen_Staff
AS Select Employee_id,Fname,Lname
From employees
Where department_id=1;

Select * From Kitchen_Staff
Order By Employee_id;

-- ALter Statements
ALTER TABLE Employees
ADD FOREIGN KEY (manager_id) REFERENCES Employees(employee_id);

ALTER TABLE Orders
ADD FOREIGN KEY (employee_id) REFERENCES Employees(employee_id);


-- Inserting data into the tables

-- Insert into jobs Table
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Head Chef', 10000, 12000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Sous Chef', 8000, 10000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Chef de Partie', 6000, 8000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Sauté Chef', 5000, 6000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Grill Chef', 5000, 6000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Pastry Chef', 6500, 7500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Relief Chef', 5000, 6000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Pantry Chef', 5000, 6000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Commis Chef', 4000, 5000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Prep Chef', 3500, 4500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Steward', 4000, 4500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Training Waiter', 2500, 3500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Host/Hostess', 3500, 4500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Bartender', 4000, 4500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Waiter', 3000, 4000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'General Manager', 10000, 12000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'FOH Manager', 8000, 9000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Cashier', 4000, 4500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Accountant', 7000, 8000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Secretary', 4000, 4500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Promotions Manager', 4000, 4500);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
VALUES (job_id_seq.nextval, 'Marketing Specialist', 6500, 8500);


-- Insert into customers table
INSERT INTO CUSTOMERS (CUSTOMER_ID, FNAME, LNAME, PHONE_NUM)
VALUES (customer_id_seq.nextval, 'Georgina', 'Wolfe', '658-7895');

INSERT INTO CUSTOMERS (CUSTOMER_ID, FNAME, LNAME, PHONE_NUM)
VALUES (customer_id_seq.nextval, 'Abubakr', 'Stacey', '457-9518');

INSERT INTO CUSTOMERS (CUSTOMER_ID, FNAME, LNAME, PHONE_NUM)
VALUES (customer_id_seq.nextval, 'Kaleem', 'Joyner', '615-7634');

INSERT INTO CUSTOMERS (CUSTOMER_ID, FNAME, LNAME, PHONE_NUM)
VALUES (customer_id_seq.nextval, 'Malcolm', 'Costa', '394-1248');

INSERT INTO CUSTOMERS (CUSTOMER_ID, FNAME, LNAME, PHONE_NUM)
VALUES (customer_id_seq.nextval, 'Henry', 'Mclean', '719-6428');

INSERT INTO CUSTOMERS (CUSTOMER_ID, FNAME, LNAME, PHONE_NUM)
VALUES (customer_id_seq.nextval, 'Sophia', 'Valdez', '652-9487');


-- INsert into departments table
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (department_id_seq.nextval, 'Kitchen');

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (department_id_seq.nextval, 'Dining Room');

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (department_id_seq.nextval, 'Marketing');

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (department_id_seq.nextval, 'Accounting');


-- INsert into suppliers table
INSERT INTO SUPPLIERS (SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_LOCATION, PHONE_NUM)
VALUES (supplier_id_seq.nextval, 'Carib Brewery', 'San Juan', '457-1248');

INSERT INTO SUPPLIERS (SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_LOCATION, PHONE_NUM)
VALUES (supplier_id_seq.nextval, 'Solo Beverage Company', 'Barataria', '327-9512');

INSERT INTO SUPPLIERS (SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_LOCATION, PHONE_NUM)
VALUES (supplier_id_seq.nextval, 'HADCO', 'San Juan', '777-6341');

INSERT INTO SUPPLIERS (SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_LOCATION, PHONE_NUM)
VALUES (supplier_id_seq.nextval, 'Westco Foods', 'Macoya', '795-1574');

INSERT INTO SUPPLIERS (SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_LOCATION, PHONE_NUM)
VALUES (supplier_id_seq.nextval, 'Best Price Liquor Mart', 'Barataria', '779-7845');

INSERT INTO SUPPLIERS (SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_LOCATION, PHONE_NUM)
VALUES (supplier_id_seq.nextval, 'Croisse Drinks Centre', 'Barataria', '654-9874');

INSERT INTO SUPPLIERS (SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_LOCATION, PHONE_NUM)
VALUES (supplier_id_seq.nextval, 'Ria’s', 'Barataria', '745-6325');


-- Insert into Employees table
INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, null, 'Cillian', 'Hayward', '784-9584', TO_DATE('17/12/2015', 'DD/MM/YYYY'), 11000, 1, 1);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 1, 'Aneesa', 'Bray', '456-9632', TO_DATE('01/05/2012', 'DD/MM/YYYY'), 8000, 1, 2);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 1, 'Tasmin', 'Hirst', '333-3030', TO_DATE('10/04/2013', 'DD/MM/YYYY'), 9000, 1, 2);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 2, 'Jez', 'Field', '751-3214', TO_DATE('31/08/2010', 'DD/MM/YYYY'), 7000, 1, 3);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 3, 'Fahima', 'Garner', '766-6666', TO_DATE('17/12/2008', 'DD/MM/YYYY'), 7000, 1, 3);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Lynda', 'Herman', '338-9624', TO_DATE('12/11/2010', 'DD/MM/YYYY'), 5500, 1, 4);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Laurel', 'Amin', '755-4555', TO_DATE('06/02/2005', 'DD/MM/YYYY'), 6000, 1, 4);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Sophie', 'Hanna', '789-9874', TO_DATE('09/03/2018', 'DD/MM/YYYY'), 6000, 1, 5);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Nancie', 'Finnegan', '652-4159', TO_DATE('17/02/2020', 'DD/MM/YYYY'), 6000, 1, 5);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Elana', 'Gross', '322-2122', TO_DATE('11/05/2021', 'DD/MM/YYYY'), 7000, 1, 6);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Shaan', 'Carson', '774-8523', TO_DATE('03/09/2000', 'DD/MM/YYYY'), 6500, 1, 6);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Amelia', 'Cooke', '455-5225', TO_DATE('16/12/2019', 'DD/MM/YYYY'), 7500, 1, 6);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Edith', 'Graves', '441-1414', TO_DATE('22/10/2013', 'DD/MM/YYYY'), 7500, 1, 6);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Jaxson', 'Kirkpatrick', '688-2266', TO_DATE('07/07/2017', 'DD/MM/YYYY'), 5500, 1, 7);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Maja', 'Rios', '429-9966', TO_DATE('30/04/2008', 'DD/MM/YYYY'), 6000, 1, 7);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Rea', 'Burris', '449-9437', TO_DATE('09/08/2015', 'DD/MM/YYYY'), 6000, 1, 8);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Ridwan', 'Daly', '632-5418', TO_DATE('21/09/2019', 'DD/MM/YYYY'), 5500, 1, 8);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Pola', 'Bloggs', '377-6418', TO_DATE('28/03/2017', 'DD/MM/YYYY'), 5000, 1, 9);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Mahira', 'Mair', '776-6685', TO_DATE('26/04/2018', 'DD/MM/YYYY'), 4500, 1, 9);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Helin', 'Cuevas', '456-1279', TO_DATE('12/06/2017', 'DD/MM/YYYY'), 4000, 1, 9);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Alissa', 'Cummings', '312-2221', TO_DATE('07/06/2015', 'DD/MM/YYYY'), 4000, 1, 9);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Tevin', 'Mckinney', '399-9996', TO_DATE('01/10/2021', 'DD/MM/YYYY'), 3500, 1, 10);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Noa', 'Hoffman', '727-7272', TO_DATE('17/02/2020', 'DD/MM/YYYY'), 3500, 1, 10);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Faye', 'William', '446-6874', TO_DATE('10/12/2015', 'DD/MM/YYYY'), 4000, 1, 11);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 4, 'Zakariyya', 'Wolf', '355-9547', TO_DATE('13/06/2017', 'DD/MM/YYYY'), 4500, 1, 11);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Miya', 'Glass', '748-9955', TO_DATE('26/04/2008', 'DD/MM/YYYY'), 4500, 1, 11);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 5, 'Tommy-Lee', 'Weston', '363-5626', TO_DATE('19/05/2020', 'DD/MM/YYYY'), 4000, 1, 11);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 1, 'Murtaza', 'Solis', '228-9478', TO_DATE('17/06/2020', 'DD/MM/YYYY'), 10000, 2, 16);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Ranveer', 'Fuentes', '222-9494', TO_DATE('05/09/2021', 'DD/MM/YYYY'), 8500, 2, 17);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Jayce', 'Brook', '412-3648', TO_DATE('05/05/2020', 'DD/MM/YYYY'), 2500, 2, 12);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Kai', 'Moran', '654-8751', TO_DATE('11/01/2013', 'DD/MM/YYYY'), 3000, 2, 12);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Ruari', 'Yoder', '745-9517', TO_DATE('17/08/2015', 'DD/MM/YYYY'), 2500, 2, 12);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Amarah', 'Huang', '322-9842', TO_DATE('17/12/2018', 'DD/MM/YYYY'), 3500, 2, 13);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Jarod', 'Willis', '311-9468', TO_DATE('28/10/2015', 'DD/MM/YYYY'), 3500, 2, 13);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Rafe', 'Esquivel', '258-7531', TO_DATE('17/06/2015', 'DD/MM/YYYY'), 4000, 2, 14);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Larissa', 'Lake', '299-6655', TO_DATE('01/12/2020', 'DD/MM/YYYY'), 4000, 2, 14);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Gracie', 'Stubbs', '477-8881', TO_DATE('13/09/2019', 'DD/MM/YYYY'), 4000, 2, 14);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Fleur', 'Warner', '235-9996', TO_DATE('17/04/2020', 'DD/MM/YYYY'), 4500, 2, 14);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Marcelina', 'Mill', '276-6617', TO_DATE('17/02/2016', 'DD/MM/YYYY'), 4000, 2, 15);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Vivien', 'Ochoa', '247-3519', TO_DATE('17/08/2014', 'DD/MM/YYYY'), 4000, 2, 15);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Iram', 'Plant', '794-8467', TO_DATE('17/08/2019', 'DD/MM/YYYY'), 4000, 2, 15);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Rida', 'Pena', '664-2448', TO_DATE('09/09/2005', 'DD/MM/YYYY'), 4000, 2, 15);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 29, 'Yazmin', 'Fleming', '755-7525', TO_DATE('15/02/2019', 'DD/MM/YYYY'), 4000, 2, 15);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Joseph', 'Stephenson', '444-4444', TO_DATE('17/02/2009', 'DD/MM/YYYY'), 4000, 4, 18);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Jodi', 'Sweeney', '222-2222', TO_DATE('10/03/2005', 'DD/MM/YYYY'), 4000, 4, 18);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Teresa', 'Foster', '355-9999', TO_DATE('22/08/2008', 'DD/MM/YYYY'), 7500, 4, 19);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Maira', 'Gilmore', '200-0000', TO_DATE('15/09/2006', 'DD/MM/YYYY'), 8000, 4, 19);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Radhika', 'Cooper', '335-5554', TO_DATE('31/07/2010', 'DD/MM/YYYY'), 4000, 4, 20);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Maximillian', 'Mcculloch', '795-1765', TO_DATE('11/11/2011', 'DD/MM/YYYY'), 4500, 3, 20);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Nolan', 'Ferguson', '497-6523', TO_DATE('09/08/2014', 'DD/MM/YYYY'), 4500, 3, 21);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, MANAGER_ID, FNAME, LNAME, PHONE_NUM, HIRE_DATE, SALARY, DEPARTMENT_ID, JOB_ID)
VALUES (employee_id_seq.nextval, 28, 'Devon', 'Marks', '776-6663', TO_DATE('31/12/2015', 'DD/MM/YYYY'), 7000, 3, 22);


-- Inset into Job history table
INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('10/11/2015', 'DD/MM/YYYY'), TO_DATE('10/12/2015', 'DD/MM/YYYY'), 29, 2, 12);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('11/12/2015', 'DD/MM/YYYY'), TO_DATE('04/09/2021', 'DD/MM/YYYY'), 29, 2, 15);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('31/08/2016', 'DD/MM/YYYY'), TO_DATE('17/09/2017', 'DD/MM/YYYY'), 4, 1, 10);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('18/09/2017', 'DD/MM/YYYY'), TO_DATE('10/05/2019', 'DD/MM/YYYY'), 4, 1, 9);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('11/05/2019', 'DD/MM/YYYY'), TO_DATE('30/08/2020', 'DD/MM/YYYY'), 4, 1, 4);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('31/12/2015', 'DD/MM/YYYY'), TO_DATE('06/07/2017', 'DD/MM/YYYY'), 14, 1, 9);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('22/11/2016', 'DD/MM/YYYY'), TO_DATE('20/06/2017', 'DD/MM/YYYY'), 17, 1, 10);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('21/06/2017', 'DD/MM/YYYY'), TO_DATE('20/09/2019', 'DD/MM/YYYY'), 17, 1, 9);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('29/01/2015', 'DD/MM/YYYY'), TO_DATE('24/09/2022', 'DD/MM/YYYY'), 12, 2, 15);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('25/09/2002', 'DD/MM/YYYY'), TO_DATE('15/06/2019', 'DD/MM/YYYY'), 12, 1, 10);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('16/06/2019', 'DD/MM/YYYY'), TO_DATE('15/12/2019', 'DD/MM/YYYY'), 12, 1, 9);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('31/12/2004', 'DD/MM/YYYY'), TO_DATE('31/12/2015', 'DD/MM/YYYY'), 2, 1,11); 

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('31/05/1999', 'DD/MM/YYYY'), TO_DATE('10/11/2012', 'DD/MM/YYYY'), 2, 1,10);

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('11/11/2012', 'DD/MM/YYYY'), TO_DATE('11/09/2020', 'DD/MM/YYYY'), 2, 1,9); 

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('12/09/2015', 'DD/MM/YYYY'), TO_DATE('30/12/2017', 'DD/MM/YYYY'), 2, 1,4); 

INSERT INTO JOB_HISTORY (JOB_HISTORY_ID, START_DATE, END_DATE, EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID)
VALUES (job_history_id_seq.nextval, TO_DATE('31/12/2017', 'DD/MM/YYYY'), TO_DATE('30/04/2020', 'DD/MM/YYYY'), 2, 1,3);


-- Insert into ingredients table
INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Cooking Cream', 250, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Garlic', 160, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Salt', 32, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Parmesan Cheese', 50, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Fettuccine Pasta', 300, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Chicken Breast', 80, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Shrimp', 75, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Olive Oil', 35, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Vege Oil', 45, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Anchovies', 20, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Lemons', 25, 'Each');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Black Pepper', 20, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Croutons', 50, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Lettuce', 60, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Butter', 40, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Flour', 85, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Sugar', 120, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Baking Soda', 45, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Baking Powder', 35, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Eggs', 50, 'Each');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Pineapple', 41, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Coconut Cream', 54, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Rum', 33, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Dry Sorrel', 21, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Mint', 12, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Lime', 9, 'Each');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Strawberries', 55, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Vanilla Extract', 10, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Cocoa Powder', 55, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Milk', 220, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Powdered Sugar', 66, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Salmon', 85, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Potato', 90, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Broccoli', 45, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'White Wine', 55, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Minced Meat(beef)', 65, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Chilli Flakes', 19, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Bread Crumbs', 33, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Orange Juice', 66, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Fruit Juice', 41, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Soda(flavoured)', 64, 'Oz');

INSERT INTO INGREDIENTS (INGREDIENT_ID, INGREDIENT_NAME, STOCK, UNIT)
VALUES (ingredient_id_seq.nextval, 'Pineapple Juice', 20, 'Oz');


-- Insert into Suppliers Lists table
INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 1, 250, 175);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 1, 350, 175);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 1, 200, 175);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 2, 10, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 2, 8, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 3, 150, 350);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 4, 250, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 4, 200, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 4, 225, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 5, 250, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 5, 200, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 6, 35, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 6, 45, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 6, 40, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 7, 75, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 7, 80, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 7, 105, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 8, 600, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 8, 450, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 8, 500, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 9, 350, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 9, 250, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 9, 250, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 10, 150, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 10, 125, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 11, 8, 1);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 11, 9, 1);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 12, 100, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 12, 90, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 12, 110, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 13, 85, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 13, 75, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 14, 118.75, 100);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 14, 135, 100);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 14, 120, 100);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 15, 350, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 15, 325, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 16, 175, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 16, 155, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 17, 300, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 17, 250, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 18, 25, 20);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 19, 20, 20);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 20, 40, 30);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 20, 50, 30);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 21, 25, 65);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 21, 35, 65);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 22, 275, 175);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 5, 23, 375, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 1, 23, 350, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 6, 23, 400, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 24, 15, 30);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 25, 35, 20);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 25, 45, 20);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 26, 1.50, 1);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 27, 275.50, 145);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 27, 250.25, 145);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 28, 266.35, 125);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 28, 214.85, 125);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 29, 50.50, 35);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 30, 120.35, 175);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 30, 145.54, 175);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 31, 41.21, 75);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 32, 1200.65, 250);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 33, 15.25, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 33, 13.75, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 34, 145.35, 200);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 4, 34, 135.58, 200);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 6, 35, 350.00, 300);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 5, 35, 275.65, 300);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 36, 45.79, 125);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 7, 37, 75.24, 50);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 3, 38, 45.62, 150);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 2, 39, 95.50, 350);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 2, 40, 105.22, 350);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 2, 41, 80.50, 350);

INSERT INTO SUPPLIER_LISTS (SUPPLIER_LIST_ID, SUPPLIER_ID, INGREDIENT_ID, PRICE, AMOUNT)
VALUES (supplier_list_id_seq.nextval, 2, 42, 125.75, 400);


-- INsert into Recipe Table
INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Chicken Alfredo', 1, 23.50, 40);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Shrimp Alfredo', 1, 35.75, 50);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Chicken Cesar Salad', 1, 28.45, 45);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Chocolate Cake', 8, 284.68, 350);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Blacked Salmon', 1, 85.95, 120);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Spicy Meatballs', 1, 14.68, 25);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Pina Colada', 1, 24.41, 40);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Sorrel Mojito', 1, 27.24, 40);

INSERT INTO RECIPES (RECIPE_ID, RECIPE_NAME, RECIPE_SERVING, RECIPE_COST, RECIPE_SELLING_PRICE)
VALUES (recipe_id_seq.nextval, 'Strawberry Daiquiri', 1, 35.24, 60);



-- Insert into Ingredients Item Table
INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 1, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 2, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 3, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 4, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 7, 5, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 6, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 8, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 15, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 35, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 12, 1);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 1, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 2, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 3, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 4, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 7, 5, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 7, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 8, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 15, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 35, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 12, 2);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .3, 2, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 3, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1.5, 4, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 6, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 8, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2.5, 10, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 11, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 12, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 3, 13, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 5, 14, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 20, 3);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 24, 16, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 24, 17, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 12, 29, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 18, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .25, 19, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .25, 3, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 4, 20, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 12, 1, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 4, 9, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .9, 28, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 12, 15, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 12, 29, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 56, 31, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 30, 4);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 2, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .3, 3, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 8, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 4, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 11, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 12, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 15, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 32, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 5, 33, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 3, 34, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 35, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 30, 5);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 2, 6);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 3, 6);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .2, 12, 6);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 20, 6);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 20, 36, 6);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 38, 6);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 42, 7);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 4, 21, 7);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 22, 7);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2.5, 23, 7);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 25, 8);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 26, 8);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 23, 8);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, .5, 24, 8);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 17, 8);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 41, 8);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 17, 9);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 4, 27, 9);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 11, 9);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 23, 9);

INSERT INTO ING_ITEMS (ING_ITEM_ID, AMOUNT, INGREDIENT_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 1, 41, 9);


-- INsert inot Orders table
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('10/11/2020', 'DD/MM/YYYY'), 45, 1);

INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('11/04/2014', 'DD/MM/YYYY'), 45, 2);

INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('10/09/2009', 'DD/MM/YYYY'), 44, 3);

INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('21/11/2006', 'DD/MM/YYYY'), 44, 3);

INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('10/10/2009', 'DD/MM/YYYY'), 45, 4);

INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('14/02/2009', 'DD/MM/YYYY'), 44, 5);

INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('31/07/2010', 'DD/MM/YYYY'), 45, 6);

INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, TO_DATE('10/01/2015', 'DD/MM/YYYY'), 44, 6);

--9
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate - interval '7' day), 44, 4);

--10
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate - interval '6' day), 45, 3);

--11
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate - interval '5' day), 44, 2);

--12
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate - interval '4' day), 45, 2);

--13
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate - interval '3' day), 44, 1);

--14
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate - interval '2' day), 45, 1);

--15
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate - interval '1' day), 44, 2);

--16
INSERT INTO ORDERS (ORDER_ID, ORDER_DATE, EMPLOYEE_ID, customer_id)
VALUES (order_id_seq.nextval, to_date(sysdate), 45, 5);


-- Insert into Order Items Table
INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 1, 1);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 5, 2, 5);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 5, 3, 9);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 9, 4, 2);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 5, 6);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 6, 7);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 7, 7);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 5, 8, 1);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 1, 2);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 8, 5);

--89
INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 8, 8, 6);

--90
INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 5, 9, 1);

--91
INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 6, 9, 2);

--92
INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 7, 9, 3);

--93
INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 7, 10, 2);

--94
INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 6, 11, 9);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 7, 11, 8);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 6, 12, 8);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 9, 12, 7);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 4, 13, 4);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 10, 13, 5);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 2, 14, 1);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 3, 14, 7);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 10, 14, 5);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 5, 15, 8);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 7, 16, 4);

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ID, RECIPE_ID)
VALUES (order_item_id_seq.nextval, 3, 16, 2);

-- Insert into Cheif orders Table
INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 7, 79, to_timestamp('10/11/2020 14:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/11/2020 15:51', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 9, 79, to_timestamp('10/11/2020 14:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/11/2020 15:51', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 6, 80, to_timestamp('11/04/2014 12:00', 'dd/mm/yyyy hh24:mi'), to_timestamp('11/04/2014 12:25', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 8, 80, to_timestamp('11/04/2014 12:00', 'dd/mm/yyyy hh24:mi'), to_timestamp('11/04/2014 12:25', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 38, 81, to_timestamp('10/09/2009 21:15', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/09/2009 21:45', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 6, 82, to_timestamp('21/11/2014 12:00', 'dd/mm/yyyy hh24:mi'), to_timestamp('21/11/2014 12:05', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 8, 82, to_timestamp('21/11/2014 12:00', 'dd/mm/yyyy hh24:mi'), to_timestamp('21/11/2014 12:05', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 9, 83, to_timestamp('10/10/2009 21:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/10/2009 22:00', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 38, 84, to_timestamp('14/02/2009 20:36', 'dd/mm/yyyy hh24:mi'), to_timestamp('14/02/2009 20:59', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 39, 85, to_timestamp('31/07/2010 19:39', 'dd/mm/yyyy hh24:mi'), to_timestamp('31/07/2010 20:00', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 7, 86, to_timestamp('10/01/2015 16:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/01/2015 17:45', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 9, 86, to_timestamp('10/01/2015 16:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/01/2015 17:45', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 7, 87, to_timestamp('10/11/2020 14:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/11/2020 15:51', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 9, 87, to_timestamp('10/11/2020 14:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/11/2020 15:51', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 7, 88, to_timestamp('10/01/2015 16:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/01/2015 17:45', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 9, 88, to_timestamp('10/01/2015 16:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/01/2015 17:45', 'dd/mm/yyyy hh24:mi'));

INSERT INTO CHEF_ORDERS (CHEF_ORDER_ID, EMPLOYEE_ID, ORDER_ITEM_ID, ORDER_STARTTIME, ORDER_ENDTIME)
VALUES (chef_order_id_seq.nextval, 9, 89, to_timestamp('10/01/2015 16:51', 'dd/mm/yyyy hh24:mi'), to_timestamp('10/01/2015 17:45', 'dd/mm/yyyy hh24:mi'));

