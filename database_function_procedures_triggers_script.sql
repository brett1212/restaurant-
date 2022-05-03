--1) Inserts Customer With The Most Orders Into VIP Table if they do not have a current active VIP Status 
Create Or Replace Procedure new_vip IS
    v_cust_id vips.customer_id%TYPE;
    v_sdate vips.start_date%TYPE;
    v_vip_period vips.vip_period%TYPE;

Begin

    Select customers.customer_id, sysdate, interval '14' day (2)
    into v_cust_id,v_sdate,v_vip_period
    From Orders
    Join Customers
    On orders.customer_id=customers.customer_id
    where customers.customer_id not In 
        (select customer_id 
        from vips
        )
    Group by customers.customer_id, fname
    order by  count(orders.customer_id) desc
    FETCH FIRST 1 ROWS ONLY;

    Insert Into vips (customer_id,start_date,vip_period) 
    Values (v_cust_id,v_sdate,v_vip_period);
    
    DBMS_OUTPUT.PUT_LINE ('A customer has been added to the VIP table');
    End new_vip;

Begin

    new_vip;

End;

select * from vips;


-- 2 Package for Profits
--Checks daily average profit
--Checks profit of one order
CREATE OR REPLACE PACKAGE check_profits IS

    v_profit Varchar2(50); 
    v_code NUMBER;
    v_msg VARCHAR2(100);
    e_ORDERIDerror EXCEPTION;
    PROCEDURE chk_avg_profit;
    Procedure order_profit(p_order_id In orders.order_id%TYPE);

END check_profits;  

Create or Replace Package Body check_profits IS

Procedure chk_avg_profit IS
Begin

    select '$' || to_char(round(avg(sum(recipe_selling_price - recipe_cost)), 2)) as "Order Average Profit"
    into v_profit
    from orders
    join order_items
    on orders.order_id = order_items.order_id
    join recipes
    on recipes.recipe_id = order_items.recipe_id
    group by orders.order_id;

    DBMS_OUTPUT.PUT_LINE ('The Daily Average Profit is: '|| v_profit);
    
    Exception
    When no_data_found Then 
     DBMS_OUTPUT.PUT_LINE('Not enough data to compute');

    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);
END chk_avg_profit;

Procedure order_profit(p_order_id In orders.order_id%TYPE) is

Begin
    IF validators.chk_ORDER(p_order_id) THEN
    RAISE e_ORDERIDerror;

    Else 

    select '$' || to_char(sum(recipe_selling_price - recipe_cost)) as "Order Total Profit"
    into v_profit
    from orders
    join order_items
    on orders.order_id = order_items.order_id
    join recipes
    on recipes.recipe_id = order_items.recipe_id
    where orders.order_id = p_order_id;
    DBMS_OUTPUT.PUT_LINE ('The Profit of Order #'||p_order_id||' is: '|| v_profit);
    ENd if;

    EXCEPTION

    WHEN e_ORDERIDerror THEN
    DBMS_OUTPUT.PUT_LINE('The Order ID you have entered is invalid. Please review your data and re enter the info.');

    
    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

    End order_profit;

End check_profits;

BEGIN

    check_profits.chk_avg_profit;
    check_profits.order_profit(2);

END;


--3) How Many Batches Of A Recipe Can We Make Based On Current Ingredient Stocks
CREATE OR Replace PROCEDURE batchess(p_recipe_name in RECIPES.RECIPE_NAME%type) IS

CURSOR cur_recipe IS 

select STOCK, AMOUNT, recipe_name
from ingredients
JOIN ing_items
  ON ingredients.ingredient_id = ing_items.ingredient_id
JOIN recipes
  ON ing_items.recipe_id = recipes.recipe_id 
where RECIPE_NAME= p_recipe_name;

type t_recipe is table of INGREDIENTS.STOCK%type
index by binary_integer;

type t_amount is table of ING_ITEMS.AMOUNT%type
index by binary_integer;

type t_resv is table of ING_ITEMS.AMOUNT%type
index by binary_integer;

v_amount    t_resv;
v_min       NUMBER :=0;
V_C_count   NUMBER :=0; 
v_stock_tab      t_recipe;
v_amount_tab     t_amount;
e_error EXCEPTION;
v_code NUMBER;
v_msg VARCHAR2(100);

BEGIN

    FOR V_REC IN cur_recipe LOOP 

        V_C_count:=V_C_count+1;
        v_stock_tab(V_C_count):=V_REC.STOCK;
        v_amount_tab(V_C_count):=V_REC.AMOUNT;

    END LOOP;

    IF V_C_count=0 THEN
    RAISE e_error;
    END IF;

     v_amount(1):=trunc(v_stock_tab(1)/v_amount_tab(1));
    v_min:= v_amount(1);

    FOR i IN 2..v_stock_tab.count LOOP
    v_amount(i):=trunc(v_stock_tab(i)/v_amount_tab(i));

        IF v_amount(i)<v_min THEN
        v_min:= v_amount(i);
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('It has '||v_min||' batches of '||p_recipe_name);

EXCEPTION

    WHEN e_error THEN
    DBMS_OUTPUT.PUT_LINE('You have entered an invalid recipe name. Please review your data and re enter the info.');

    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

END batchess;

Begin
batchess('Chicken Alferdo');
End;

--4) create new record for an employee
CREATE OR REPLACE PROCEDURE new_emp(p_manid IN EMPLOYEES.EMPLOYEE_ID%type, p_empfn IN EMPLOYEES.FNAME%type, p_empln IN EMPLOYEES.LNAME%type, p_empphone IN EMPLOYEES.PHONE_NUM%type, p_hiredate IN EMPLOYEES.HIRE_DATE%type, p_empsal IN EMPLOYEES.SALARY%type, p_empdeptid IN EMPLOYEES.DEPARTMENT_ID%type, p_jodid IN EMPLOYEES.JOB_ID%type) IS
e_depterror EXCEPTION;
e_joberror EXCEPTION;
e_managererror EXCEPTION;
v_code NUMBER;
v_msg VARCHAR2(100);

BEGIN

    IF validators.chk_dept(p_empdeptid) THEN
    RAISE e_depterror;

    ELSIF validators.chk_job(p_jodid) THEN
    RAISE e_joberror;

    ELSIF validators.chk_manageremp(p_manid) THEN
    RAISE e_managererror;

    ELSE 
    INSERT INTO EMPLOYEES(EMPLOYEE_ID,	MANAGER_ID,	FNAME,	LNAME,	PHONE_NUM,	HIRE_DATE,	SALARY,	DEPARTMENT_ID,	JOB_ID)
    VALUES(employee_id_seq.nextval, p_manid , p_empfn, p_empln, p_empphone, p_hiredate, p_empsal, p_empdeptid, p_jodid);

    END IF;

EXCEPTION

    WHEN e_depterror THEN
    DBMS_OUTPUT.PUT_LINE('The Department ID you have entered is invalid. Please review your data and re enter the info.');

    WHEN e_joberror THEN
    DBMS_OUTPUT.PUT_LINE('The Job ID you have entered is invalid. Please review your data and re enter the info.');

    WHEN e_managererror THEN
    DBMS_OUTPUT.PUT_LINE('The Manager ID you have entered is invalid. Please review your data and re enter the info.');

    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

END new_emp;

Begin
new_emp(4,'Divina','Luca','1868-547-4353',sysdate,4000,4,2);
End;

Select * From employees 
Where fname='Divina';

--5) Finds the suppiler with the cheapest price for an ingredient 

CREATE OR REPLACE PROCEDURE cheapestsupply(p_ingredient IN INGREDIENTS.INGREDIENT_NAME%type) IS
v_ing_name                          INGREDIENTS.INGREDIENT_NAME%TYPE;
v_price                             SUPPLIER_LISTS.PRICE%TYPE;
v_supplier_name                     SUPPLIERS.SUPPLIER_NAME%TYPE;
v_amount                            SUPPLIER_LISTS.AMOUNT%TYPE;
v_code NUMBER;
v_msg VARCHAR2(100);

BEGIN

    select ingredient_name, PRICE, supplier_name, AMOUNT
    into v_ing_name, v_price, v_supplier_name, v_amount
    from supplier_lists 
    join ingredients
    on ingredients.ingredient_id = supplier_lists.ingredient_id
    join suppliers
    on suppliers.supplier_id = supplier_lists.supplier_id
    where ingredient_name = p_ingredient
    order by PRICE ASC
    FETCH FIRST 1 ROWS ONLY;

DBMS_OUTPUT.PUT_LINE('The cheapest supplier for '||v_ing_name||' is '||v_supplier_name||' and the cost is $'||v_price|| ' for '||v_amount||'oz');

EXCEPTION

    WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('The ingredient name you have entered is either invalid or spelt inncorrectly. Please review your data and re enter the info.');


    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

END cheapestsupply;

begin
cheapestsupply('Salt');
end;


--6) how many years an employee is working or worked for the company
CREATE OR REPLACE FUNCTION yearsworking(p_empid IN EMPLOYEES.EMPLOYEE_ID%type) RETURN NUMBER IS

CURSOR yearsworked IS
SELECT START_DATE, END_DATE
FROM JOB_HISTORY
WHERE EMPLOYEE_ID = p_empid;

v_numberyears                       NUMBER:= 0;
e_emperror                          EXCEPTION;

BEGIN

FOR V_REC IN yearsworked LOOP 
v_numberyears:=v_numberyears+TRUNC((MONTHS_BETWEEN(V_REC.END_DATE,V_REC.START_DATE)/12),0);
END LOOP;

RETURN v_numberyears;

exception
  when no_data_found 
  then RETURN 0;

END yearsworking;

begin
DBMS_OUTPUT.PUT_LINE(yearsworking(2));
end;

--7) salary increase base on how much years worked using the yearsworking Function above
CREATE OR REPLACE PROCEDURE raisesal(p_emp IN EMPLOYEES.EMPLOYEE_ID%type) IS

v_salary                        EMPLOYEES.SALARY%TYPE;
e_emperror EXCEPTION;
v_code NUMBER;
v_msg VARCHAR2(100);
v_sal_increase                  EMPLOYEES.SALARY%TYPE;

BEGIN

    IF validators.chk_manageremp(p_emp) THEN 
        RAISE e_emperror;

    ELSE
        SELECT SALARY
        INTO v_salary
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID=p_emp;

    IF yearsworking(p_emp)>0 THEN
                case

                    when yearsworking(p_emp)>5 AND yearsworking(p_emp)<10 then v_sal_increase:= v_salary*.05;
                    when yearsworking(p_emp) >=10 AND yearsworking(p_emp)<15 then v_sal_increase:= v_salary*.10;
                    when yearsworking(p_emp) >15 then v_sal_increase:= v_salary*.15;
                    else v_sal_increase:=0;

                END CASE;

            ELSE
                RAISE e_emperror;

            END IF;

        update EMPLOYEES
        set salary=v_salary+ v_sal_increase
        where EMPLOYEE_ID = p_emp;

    END IF;

   v_salary:= v_salary+ v_sal_increase;

 DBMS_OUTPUT.PUT_LINE('The Employee ID: '||p_emp||' got a $'||v_sal_increase||' of salary incease. Total salary is now $'||v_salary);

EXCEPTION

    WHEN e_emperror THEN
    DBMS_OUTPUT.PUT_LINE('The Employee ID You have entered is invalid. Please review your data and re enter the info.');

    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

END raisesal;

Begin
raisesal(2);
End;

--8) Fastest Time an employee does an order 
Create or Replace Procedure Fast_emp(p_fname in employees.fname%TyPE) IS 

v_fname        employees.fname%TYPE;
v_time         varchar2(50);
v_code NUMBER;
v_msg VARCHAR2(100);

Begin

    select fname, EXTRACT(minute from min(order_endtime - order_starttime)) || ' Minutes(s)' 
    into v_fname,v_time
    from chef_orders
    join employees
        on chef_orders.employee_id = employees.employee_id
        Where fname=p_fname
    group by fname;

DBMS_OUTPUT.PUT_LINE(p_fname|| ' ' ||v_time);

Exception 
When no_data_found Then
DBMS_OUTPUT.PUT_LINE('Erorr To Solve Please Read The Options:' || chr(10) || '1) The Name You Entered Does not exist in these records '
|| chr(10) || '2) The Name is Mispelt ' || chr(10) ||'3) You entered an incorrect value or value type');

 WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);
End Fast_emp;

Begin 

Fast_emp('Marcelina');
Fast_emp(5);

end;

--9) Fastest Time a job is done by departments
Create or Replace Procedure Fast_job(p_title IN jobs.job_title%TYPE) Is

v_title jobs.job_title%TYPE;
v_time varchar(50);
v_code NUMBER;
v_msg VARCHAR2(100);

Begin

    select job_title, EXTRACT(minute from min(order_endtime - order_starttime) ) || ' Minutes(s)' 
    into v_title,v_time
    from chef_orders
    join employees
        on chef_orders.employee_id = employees.employee_id
    join jobs
        on jobs.job_id = employees.job_id
        where job_title=p_title
    group by jobs.job_id, job_title;


DBMS_OUTPUT.PUT_LINE(p_title|| ' ' ||v_time);

Exception 

    When no_data_found Then
    DBMS_OUTPUT.PUT_LINE('Erorr To Solve Please Read The Options:' || chr(10) || '1) The Title You Entered Does not exist in these records '
    || chr(10) || '2) The Title is Mispelt ' || chr(10) ||'3) You entered an incorrect value or value type');

     WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

End Fast_job;

Begin

    Fast_job('Bartender');
    Fast_job('x');
    Fast_job(7);

End;


--10 Minimum Maximum and Average Cost of 1 recipe
Create or Replace Procedure Max_Min_Avg(p_recipe_name in recipes.recipe_name%TYPE) Is 

    v_max varchar2(50);
    v_min varchar2(50);
    v_avg varchar2(50);
    v_code NUMBER;
    v_msg VARCHAR2(100);

Begin

    select '$'||round(sum(max((price/supplier_lists.amount) * ing_items.amount)), 2),
           '$'|| round(sum(min((price/supplier_lists.amount) * ing_items.amount)), 2),
           '$'||round(sum(avg((price/supplier_lists.amount) * ing_items.amount)), 2)

    into v_max,v_min,v_avg
    from recipes
    JOIN ing_items
    ON recipes.recipe_id = ing_items.recipe_id
    join supplier_lists
    ON ing_items.ingredient_id = supplier_lists.ingredient_id
    where recipe_name=p_recipe_name
    group by ing_items.ingredient_id;


    DBMS_OUTPUT.PUT_LINE('Recipe: '||p_recipe_name|| chr(10) ||
                      'Highest Cost: '||v_max|| chr(10) ||
                      'Lowest Cost: ' ||v_min|| chr(10) || 
                      'Average Cost: ' ||v_avg);  

Exception 

    When no_data_found Then
    DBMS_OUTPUT.PUT_LINE('Erorr To Solve Please Read The Options:' || chr(10) || '1) The Recipe name You Entered Does not exist in these records '
    || chr(10) || '2) The Recipe Name is Mispelt ' || chr(10) ||'3) You entered an incorrect value or value type');

    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

End Max_Min_Avg;

Begin

    Max_Min_Avg('Shrimp Alfredo');;

End;

-- 11) Displays the ratings and reviews of a recipe 
Create or Replace Procedure Order_rating(p_recipe_name IN recipes.recipe_name%TYPE)is

v_recipe_name recipes.recipe_name%TYPE;
v_rating varchar(50);
v_reviews Number(10);
v_code NUMBER;
v_msg VARCHAR2(100);

Begin

    select recipe_name, avg(order_item_star_rating) || ' Star(s) ', count(order_item_star_rating)
    into v_recipe_name,v_rating,v_reviews
    from order_items
    join recipes
    on order_items.recipe_id = recipes.recipe_id
    where recipe_name=p_recipe_name
    group by recipe_name;

    DBMS_OUTPUT.PUT_LINE('Recipe: '||p_recipe_name|| chr(10) ||'Average Star Rating: ' ||v_rating|| chr(10) || 'Number of Reviews: ' ||v_reviews); 

Exception 

When no_data_found Then

    DBMS_OUTPUT.PUT_LINE('Erorr To Solve Please Read The Options:' || chr(10) || '1) The Recipe name You Entered Does not exist in these records '
    || chr(10) || '2) The Recipe Name is Mispelt ' || chr(10) ||'3) You entered an incorrect value or value type');
WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

End Order_rating;

Begin   

    Order_rating('Chicken Cesar Salad');
    Order_rating(5);

End;

--12 A Package of checkers to validate Primary/Foriegn Keys of tables
Create or Replace Package validators is

    Function chk_recipe_id(p_id in recipes.recipe_id%TYPE) Return Boolean ;
    FUNCTION chk_dept(p_deptno in DEPARTMENTS.DEPARTMENT_ID%type)Return Boolean;
    FUNCTION chk_job(p_jobid in JOBS.JOB_ID%type) RETURN BOOLEAN;
    FUNCTION chk_manageremp(p_managerid in EMPLOYEES.EMPLOYEE_ID%type) RETURN BOOLEAN;
    FUNCTION chk_supplier(p_supplierid in SUPPLIERS.SUPPLIER_ID%type) RETURN BOOLEAN;
    FUNCTION chk_ingredient(p_ingid in INGREDIENTS.INGREDIENT_ID%type) RETURN BOOLEAN;
    FUNCTION chk_ORDER_ITEMS(p_OIid in ORDER_ITEMS.ORDER_ITEM_ID%type) RETURN BOOLEAN;
    FUNCTION chk_ORDER(p_orderid in ORDERS.ORDER_ID%type) RETURN BOOLEAN;

End validators;

Create or Replace Package Body validators Is

Function chk_recipe_id(p_id in recipes.recipe_id%TYPE) Return Boolean IS 
v_id  recipes.recipe_id%TYPE;

Begin

    Select recipe_id into v_id
    From recipes
    where recipe_id=p_id;
    Return false;

EXCEPTION 

 WHEN NO_DATA_FOUND THEN 
 RETURN true;

End chk_recipe_id;

FUNCTION chk_dept(p_deptno in DEPARTMENTS.DEPARTMENT_ID%type) RETURN BOOLEAN IS
v_dept_id          DEPARTMENTS.DEPARTMENT_ID%type;
v_id               BOOLEAN:=false;

BEGIN

    select DEPARTMENT_ID into v_dept_id
    from DEPARTMENTS
    where DEPARTMENT_ID = p_deptno;

RETURN v_id;

exception
  when no_data_found 
  then RETURN true;

END chk_dept;

FUNCTION chk_job(p_jobid in JOBS.JOB_ID%type) RETURN BOOLEAN IS
v_job_id          JOBS.JOB_ID%type;
v_id               BOOLEAN:=false;

BEGIN

    select JOB_ID into v_job_id
    from JOBS
    where JOB_ID = p_jobid;

RETURN v_id;

exception
  when no_data_found 
  then RETURN true;
 
END chk_job;

FUNCTION chk_manageremp(p_managerid in EMPLOYEES.EMPLOYEE_ID%type) RETURN BOOLEAN IS
v_manager_id          EMPLOYEES.EMPLOYEE_ID%type;
v_id               BOOLEAN:=false;

BEGIN

    select EMPLOYEE_ID into v_manager_id
    from EMPLOYEES
    where EMPLOYEE_ID = p_managerid;

    RETURN v_id;

exception
  when no_data_found 
  then RETURN true;

END chk_manageremp;


FUNCTION chk_supplier(p_supplierid in SUPPLIERS.SUPPLIER_ID%type) RETURN BOOLEAN IS
v_supplier_id          SUPPLIERS.SUPPLIER_ID%type;
v_id               BOOLEAN:=false;

BEGIN

    select SUPPLIER_ID into v_supplier_id
    from SUPPLIERS
    where SUPPLIER_ID = p_supplierid;

    RETURN v_id;

exception
  when no_data_found 
  then RETURN true;


END chk_supplier;

FUNCTION chk_ingredient(p_ingid in INGREDIENTS.INGREDIENT_ID%type) RETURN BOOLEAN IS
v_ingredient_id          INGREDIENTS.INGREDIENT_ID%type;
v_id               BOOLEAN:=false;

BEGIN

    select INGREDIENT_ID into v_ingredient_id
    from INGREDIENTS
    where INGREDIENT_ID = p_ingid;

    RETURN v_id;

exception
  when no_data_found 
  then RETURN true;

END chk_ingredient;


FUNCTION chk_ORDER_ITEMS(p_OIid in ORDER_ITEMS.ORDER_ITEM_ID%type) RETURN BOOLEAN IS
v_ORDER_ITEM_ID          ORDER_ITEMS.ORDER_ITEM_ID%type;
v_id               BOOLEAN:=false;

BEGIN

    select ORDER_ITEM_ID into v_ORDER_ITEM_ID
    from ORDER_ITEMS
    where ORDER_ITEM_ID = p_OIid;

    RETURN v_id;

exception
  when no_data_found 
  then RETURN true;

END chk_ORDER_ITEMS;


FUNCTION chk_ORDER(p_orderid in ORDERS.ORDER_ID%type) RETURN BOOLEAN IS
v_ORDER_ID          ORDERS.ORDER_ID%type;
v_id               BOOLEAN:=false;

BEGIN

    select ORDER_ID into v_ORDER_ID
    from ORDERS
    where ORDER_ID = p_orderid;

    RETURN v_id;

exception
  when no_data_found 
  then RETURN true;

END chk_ORDER;

End validators;

Begin

    If validators.chk_recipe_id(9) Then

    DBMS_OUTPUT.PUT_LINE('Recipe ID Not Available');
    else 
    DBMS_OUTPUT.PUT_LINE('Recipe ID Available');

End if;

End;

--13 Creates a New Recipe
Create or Replace Procedure new_recipe(
                            p_name in recipes.recipe_name%TYPE, 
                            p_rep_serv in recipes.recipe_serving%TYPE,
                            p_cost IN recipes.recipe_cost%TYPE, 
                            p_selling_price IN recipes.recipe_selling_price%TYPE
) Is 

v_code NUMBER;
v_msg VARCHAR2(100);

Begin

    insert into recipes(recipe_id,recipe_name,recipe_serving,recipe_cost,recipe_selling_price)
    values(recipe_id_seq.nextval,p_name,p_rep_serv,p_cost,p_selling_price);

EXCEPTION

    WHEN others THEN
        v_code := sqlcode;
        v_msg := sqlerrm;
        DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

End new_recipe;

Begin

    new_recipe('Fugu',5,100,500);

End;

  select RECIPE_NAME,	RECIPE_SERVING,	RECIPE_COST, RECIPE_SELLING_PRICE
    from RECIPES
    where RECIPE_NAME='Fugu';


--14 Number Of Times Each Recipe was Sold
Create Or Replace Procedure No_Sold(p_recipe_name in recipes.recipe_name%TYPE) Is
v_count Number;
v_recipe_name recipes.recipe_name%TYPE;
v_code NUMBER;
v_msg VARCHAR2(100);


Begin

    select recipe_name, count(order_items.recipe_id)
    into v_recipe_name,v_count
    from  orders
    JOIN order_items
      ON orders.order_id = order_items.order_id
    JOIN recipes
      ON order_items.recipe_id = recipes.recipe_id
    join orders
        on orders.order_id = order_items.order_id
    where recipe_name=p_recipe_name
    group by recipe_name;

    IF SQL%NOTFOUND THEN
    Raise no_data_found;
    End if;

DBMS_OUTPUT.PUT_LINE('Recipe: '||p_recipe_name|| chr(10) ||'Number of Times Sold: '||v_count);

Exception 

    When no_data_found Then
    DBMS_OUTPUT.PUT_LINE('Erorr To Solve Please Read The Options:' || chr(10) || '1) The Recipe name You Entered Does not exist in these records '
    || chr(10) || '2) The Recipe Name is Mispelt ' || chr(10) ||'3) You entered an incorrect value or value type');

    WHEN others THEN
        v_code := sqlcode;
        v_msg := sqlerrm;
        DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

ENd No_Sold;

Begin

    No_Sold('Chicken Alfredo');
    No_Sold(50);

End

--15) How many Ingredients is Needed to make R Batches of a recipe with Where Recipe names Match
Create or Replace Procedure Multi_Batches(p_recipe_name in recipes.recipe_name%TYPE, p_num Number) is   

    Cursor recipe is 
    select recipe_name, ingredient_name, to_char(amount*p_num) || ' ' || unit as Amount
    from ingredients
    JOIN ing_items
      ON ingredients.ingredient_id = ing_items.ingredient_id
    JOIN recipes
      ON ing_items.recipe_id = recipes.recipe_id
      where recipe_name=p_recipe_name
    order by recipes.recipe_id;


    v_code NUMBER;
    v_msg VARCHAR2(100);

Begin

    DBMS_OUTPUT.PUT_LINE('Recipe: '||p_recipe_name);
    DBMS_OUTPUT.PUT_LINE('Ingredients For '||p_num|| ' Batches: '|| chr(10));

    For rec_recipe in recipe Loop

    DBMS_OUTPUT.PUT_LINE(rec_recipe.ingredient_name||' '||rec_recipe.Amount|| chr(10));

    End Loop;

EXCEPTION

    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('There is not a recipe by that name.'|| chr(10)||'Please make sure that the data is entered correctly');


    WHEN others THEN
        v_code := sqlcode;
        v_msg := sqlerrm;
        DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);


End Multi_Batches;

Begin

    Multi_Batches('Chicken Alfredo',2.5);

End;

--16 Creates new Ingredient
Create or Replace Procedure new_ingredients(
                            p_name in ingredients.ingredient_name%TYPE, 
                            p_stock ingredients.stock%TYPE,
                            p_unit IN ingredients.unit%TYPE
                        
) Is 

Begin

    insert into ingredients(ingredient_id,ingredient_name,stock,unit)
    values(ingredient_id_seq.nextval,p_name,p_stock,p_unit);

End new_ingredients;

Begin
    new_ingredients('Sugar',50,'Oz');

End;

select INGREDIENT_NAME,	STOCK,	UNIT
from INGREDIENTS
where INGREDIENT_NAME='Sugar';

-- 17 Which cashier cashed which order on which date
Create Or Replace Procedure Emp_Order(p_order_id IN orders.order_id%TYPE) IS 

v_order_id  varchar(50);
v_full_name employees.fname%TYPE;
v_date orders.order_date%TYPE;

Begin

    select 'Order #' || orders.order_id, fname || ' ' || lname, order_date 
    into v_order_id,v_full_name,v_date
    from orders
    join employees 
    on orders.employee_id  = employees.employee_id
    join jobs on employees.job_id = jobs.job_id
    Where orders.order_id=p_order_id;

    DBMS_OUTPUT.PUT_LINE(v_full_name ||' cashed '||v_order_id ||' on '||v_date);

Exception 

    When VALUE_ERROR Then
    DBMS_OUTPUT.PUT_LINE('The Order Id Entered is not a number ');

    When no_data_found Then
    DBMS_OUTPUT.PUT_LINE('The Order Id Entered has not been issued or does not exist');

    when INVALID_NUMBER then
    DBMS_OUTPUT.PUT_LINE('Not a number');

    When Others Then
    DBMS_OUTPUT.PUT_LINE('An unknown error has occured Please Try Again');

End Emp_Order;

Begin

    Emp_Order(3);
    Emp_Order(6);
    Emp_Order(23);

End

--18 Job History of an employee
Create Or Replace Procedure Job_History_Search(p_name IN employees.fname%TYPE) Is

    Cursor job_h is select fname || ' ' || lname as "FULLN", job_title, start_date, end_date
    from employees 
    join job_history
    on employees.employee_id = job_history.employee_id
    join jobs
    on job_history.job_id = jobs.job_id
    where fname || ' ' || lname= p_name 
    order by start_date;

Begin

    DBMS_OUTPUT.PUT_LINE('Records of : '||p_name);

    For rec_job_h in job_h Loop
    DBMS_OUTPUT.PUT_LINE( 'Past Job: ' ||rec_job_h.job_title||' Start Date: '|| rec_job_h.start_date||' End Date: '||rec_job_h.end_date);

    End Loop;

End Job_History_Search;


Begin

    Job_History_Search('Aneesa Bray');

End;

--19) Amount of Orders a Chef has served
Create Or Replace Procedure Chefs(p_name IN kitchen_staff.fname%TYPE ) Is

    v_name kitchen_staff.fname%TYPE;
    v_count Number;

Begin

    select fname || ' ' || lname as  , count(chef_orders.chef_order_id)
    into v_name,v_count
    from kitchen_staff
    join chef_orders
    on chef_orders.employee_id = kitchen_staff.employee_id
    Where fname || ' ' || lname=p_name
    group by fname || ' ' || lname;

    DBMS_OUTPUT.PUT_LINE('Chef: '||p_name || 'Completed Orders:' ||v_count);

Exception 

    When no_data_found Then
    DBMS_OUTPUT.PUT_LINE('The name you entered does not exist or is mispelt');
    End Chefs;

Begin
    Chefs('Nancie Finnegan');
End;

Begin
    Chefs('Jake');
End;

--20) Amount of orders a Customer has purchased

Create Or Replace Procedure Customer_Orders(p_name IN customers.fname%TYPE) Is 
v_name customers.fname%TYPE;
v_count Number;
v_code NUMBER;
v_msg VARCHAR2(100);

Begin

    Select fname || ' ' || lname ,count(orders.customer_id) 
    into v_name,v_count
    From Orders
    Join Customers
    On orders.customer_id=customers.customer_id
    Where fname ||' ' ||lname=p_name
    Group by fname || ' ' || lname;
    DBMS_OUTPUT.PUT_LINE(p_name||' '||v_count);

Exception 

    When no_data_found Then
    DBMS_OUTPUT.PUT_LINE('The Customer is not recorded in our database');
     
    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

End Customer_Orders;

Begin
    Customer_Orders('Kaleem Joyner');
End

--21) create a new record of a ingredient price per amount and the supplier who sells it

CREATE OR REPLACE PROCEDURE new_SUPPLIER_LISTS(p_supplierid IN SUPPLIER_LISTS.SUPPLIER_ID%TYPE,
                                                p_ingid IN SUPPLIER_LISTS.INGREDIENT_ID%TYPE,	
                                                p_price IN SUPPLIER_LISTS.PRICE%TYPE,	
                                                p_amount IN SUPPLIER_LISTS.AMOUNT%TYPE) IS
e_suppliererror EXCEPTION;
e_ingerror EXCEPTION;
v_code NUMBER;
v_msg VARCHAR2(100);

BEGIN

    IF validators.chk_ingredient(p_ingid) THEN
    RAISE e_ingerror;

    ELSIF validators.chk_supplier(p_supplierid) THEN
    RAISE e_suppliererror;

    ELSE 
    INSERT INTO SUPPLIER_LISTS(SUPPLIER_LIST_ID,	SUPPLIER_ID, INGREDIENT_ID,	PRICE, AMOUNT)
    VALUES(SUPPLIER_LIST_ID_SEQ.nextval, p_supplierid , p_ingid, p_price, p_amount);

    END IF;

EXCEPTION

    WHEN e_ingerror THEN
    DBMS_OUTPUT.PUT_LINE('The Ingredient ID you have entered is invalid. Please review your data and re enter the info.');

    WHEN e_suppliererror THEN
    DBMS_OUTPUT.PUT_LINE('The Supplier ID you have entered is invalid. Please review your data and re enter the info.');


    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

END new_SUPPLIER_LISTS;

begin

new_SUPPLIER_LISTS(1, 3, 50, 150);

end

select SUPPLIER_ID,	INGREDIENT_ID,	PRICE,	AMOUNT
from SUPPLIER_LISTS
where SUPPLIER_ID=1 and INGREDIENT_ID=3;


--22) convert to or from these types: kg, lbs, oz, g
CREATE OR REPLACE PROCEDURE new_convert(p_numbercon IN number, p_from IN varchar, p_to varchar, p_converted OUT varchar) IS

e_convert            EXCEPTION;
v_code NUMBER;
v_msg VARCHAR2(100);

BEGIN

    IF p_from ='kg' AND p_to = 'oz' THEN
        p_converted:=p_numbercon * 35.274||'oz';
    ELSIF p_from ='oz' AND p_to = 'kg' THEN
        p_converted:=p_numbercon * 0.0283495||'kg';
    ELSIF p_from ='oz' AND p_to = 'lbs' THEN
        p_converted:=p_numbercon * 0.0625||'lbs';
    ELSIF p_from ='lbs' AND p_to = 'oz' THEN
        p_converted:=p_numbercon * 16||'oz';
    ELSIF p_from ='g' AND p_to = 'kg' THEN
        p_converted:=p_numbercon * 0.001||'kg';
    ELSIF p_from ='kg' AND p_to = 'g' THEN
        p_converted:=p_numbercon * 1000||'g';
    ELSIF p_from ='g' AND p_to = 'oz' THEN
        p_converted:=p_numbercon * 0.035274||'oz';
    ELSIF p_from ='oz' AND p_to = 'g' THEN
        p_converted:=p_numbercon * 28.3495||'g';
    ELSIF p_from ='lbs' AND p_to = 'g' THEN
        p_converted:=p_numbercon * 453.592||'g';
    ELSIF p_from ='g' AND p_to = 'lbs' THEN
        p_converted:=p_numbercon * 0.00220462||'lbs';
    ELSIF p_from ='kg' AND p_to = 'lbs' THEN
        p_converted:=p_numbercon * 2.20462||'lbs';
    ELSIF p_from ='lbs' AND p_to = 'kg' THEN
        p_converted:=p_numbercon * 0.453592||'kg';
    ELSE
        RAISE e_convert;
    END IF;


EXCEPTION

    WHEN e_convert THEN
    DBMS_OUTPUT.PUT_LINE('Can only convert to or from these types: kg, lbs, oz, g'|| chr(10)||'So please double check the data you entered');

    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);


END new_convert;

declare
a_new    varchar(20);

begin
new_convert(1, 'kg', 'g', a_new);
DBMS_OUTPUT.PUT_LINE(a_new);
end;


--23) creates the ingredients,amount of ingredients to the recipe via recipe id
create or replace PROCEDURE new_standardize_recipe(p_amount IN ING_ITEMS.AMOUNT%TYPE,	
                                                    p_ingid IN ING_ITEMS.INGREDIENT_ID%TYPE,
                                                    p_recipeid IN ING_ITEMS.RECIPE_ID%TYPE) IS
e_reciderror EXCEPTION;
e_ingerror EXCEPTION;
v_code NUMBER;
v_msg VARCHAR2(100);
BEGIN
    IF validators.chk_ingredient(p_ingid) THEN
    RAISE e_ingerror;
    ELSIF validators.chk_recipe_id(p_recipeid) THEN
    RAISE e_reciderror;
    ELSE 
    INSERT INTO ING_ITEMS(ING_ITEM_ID,	AMOUNT,	INGREDIENT_ID,	RECIPE_ID)
    VALUES(ING_ITEM_ID_SEQ.nextval, p_amount , p_ingid, p_recipeid);
    END IF;
EXCEPTION
    WHEN e_ingerror THEN
    DBMS_OUTPUT.PUT_LINE('The Ingredient ID you have entered is invalid. Please review your data and re enter the info.');
    WHEN e_reciderror THEN
    DBMS_OUTPUT.PUT_LINE('The Recipe ID you have entered is invalid. Please review your data and re enter the info.');
    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);
END new_standardize_recipe;

begin

new_standardize_recipe(.5, 5, 5);

end

select AMOUNT,	INGREDIENT_ID,	RECIPE_ID
from ING_ITEMS
where INGREDIENT_ID=5 and RECIPE_ID=5;


--24) TRIGGER to minus stock when a new order is inserted into the ORDER_ITEMS table
CREATE OR REPLACE TRIGGER update_stock AFTER INSERT ON ORDER_ITEMS

BEGIN

    DECLARE

        CURSOR cur_recipeing (p_Rname varchar)IS
        select INGREDIENT_NAME, AMOUNT
        from ingredients
        JOIN ing_items
          ON ingredients.ingredient_id = ing_items.ingredient_id
        JOIN recipes
          ON ing_items.recipe_id = recipes.recipe_id 
        where RECIPE_NAME=p_Rname;


        v_stock                 INGREDIENTS.STOCK%TYPE;
        v_recipename              recipes.RECIPE_NAME%TYPE;
        v_recipeing             cur_recipeing%ROWTYPE;


    BEGIN

        SELECT RECIPE_NAME 
        INTO v_recipename
        FROM RECIPES 
        WHERE RECIPE_ID=(SELECT RECIPE_ID FROM ORDER_ITEMS WHERE ORDER_ITEM_ID=(SELECT max(ORDER_ITEM_ID) FROM ORDER_ITEMS));


        OPEN cur_recipeing (v_recipename);

        LOOP

            FETCH cur_recipeing INTO v_recipeing;
            EXIT WHEN cur_recipeing%NOTFOUND;

            SELECT STOCK 
            INTO v_stock
            FROM INGREDIENTS 
            WHERE INGREDIENT_NAME=v_recipeing.INGREDIENT_NAME;

            v_stock:=v_stock-v_recipeing.AMOUNT;

            UPDATE INGREDIENTS
            SET STOCK=v_stock
            WHERE INGREDIENT_NAME=v_recipeing.INGREDIENT_NAME;


        END LOOP;

        CLOSE cur_recipeing;

    END;

END;



--25) TRIGGER to add back stock when a order is deleted from the ORDER_ITEMS table (mistake order)
CREATE OR REPLACE TRIGGER update_stockdel AFTER DELETE ON ORDER_ITEMS

BEGIN
    DECLARE

        CURSOR cur_recipeing (p_Rname varchar)IS
        select INGREDIENT_NAME, AMOUNT
        from ingredients
        JOIN ing_items
          ON ingredients.ingredient_id = ing_items.ingredient_id
        JOIN recipes
          ON ing_items.recipe_id = recipes.recipe_id 
        where RECIPE_NAME=p_Rname;

        v_stock                 INGREDIENTS.STOCK%TYPE;
        v_recipename              recipes.RECIPE_NAME%TYPE;
        v_recipeing             cur_recipeing%ROWTYPE;

    BEGIN

        SELECT RECIPE_NAME 
        INTO v_recipename
        FROM RECIPES 
        WHERE RECIPE_ID=(SELECT RECIPE_ID FROM ORDER_ITEMS WHERE ORDER_ITEM_ID=(SELECT max(ORDER_ITEM_ID) FROM ORDER_ITEMS));

        OPEN cur_recipeing (v_recipename);

        LOOP

            FETCH cur_recipeing INTO v_recipeing;
            EXIT WHEN cur_recipeing%NOTFOUND;

            SELECT STOCK 
            INTO v_stock
            FROM INGREDIENTS 
            WHERE INGREDIENT_NAME=v_recipeing.INGREDIENT_NAME;

            v_stock:=v_stock+v_recipeing.AMOUNT;

            UPDATE INGREDIENTS
            SET STOCK=v_stock
            WHERE INGREDIENT_NAME=v_recipeing.INGREDIENT_NAME;
          

        END LOOP;

        CLOSE cur_recipeing;
      
    END;
END;


--26) package to delete employee, order item, ingredients and recipes
CREATE OR Replace Package delete_rec IS

PROCEDURE del_emp(p_empid IN EMPLOYEES.EMPLOYEE_ID%TYPE);
PROCEDURE del_ORDER_ITEMS(p_ORDER_ITEMid IN ORDER_ITEMS.ORDER_ITEM_ID%TYPE);
PROCEDURE del_INGREDIENTS(p_ingid IN INGREDIENTS.INGREDIENT_ID%TYPE);
PROCEDURE del_RECIPES(p_recipeid IN RECIPES.RECIPE_ID%TYPE);

END delete_rec;

CREATE OR Replace Package Body delete_rec IS

PROCEDURE del_emp(p_empid IN EMPLOYEES.EMPLOYEE_ID%TYPE) IS
e_empiderror            EXCEPTION;

BEGIN

    IF validators.chk_manageremp(p_empid) THEN
    RAISE e_empiderror;
    ELSE
    DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID=p_empid;
    END IF;

EXCEPTION

    WHEN e_empiderror THEN
    DBMS_OUTPUT.PUT_LINE('The Employee ID you have entered is invalid. Please review your data and re enter the info.');

END del_emp;


PROCEDURE del_ORDER_ITEMS(p_ORDER_ITEMid IN ORDER_ITEMS.ORDER_ITEM_ID%TYPE) IS
e_ORDER_ITEMSerror            EXCEPTION;

BEGIN

    IF validators.chk_ORDER_ITEMS(p_ORDER_ITEMid) THEN
    RAISE e_ORDER_ITEMSerror;
    ELSE
    DELETE FROM ORDER_ITEMS WHERE ORDER_ITEM_ID=p_ORDER_ITEMid;
    END IF;

EXCEPTION

    WHEN e_ORDER_ITEMSerror THEN
    DBMS_OUTPUT.PUT_LINE('The ORDER_ITEM ID you have entered is invalid. Please review your data and re enter the info.');

END del_ORDER_ITEMS;


PROCEDURE del_INGREDIENTS(p_ingid IN INGREDIENTS.INGREDIENT_ID%TYPE) IS
e_ingiderror            EXCEPTION;

BEGIN

    IF validators.chk_ingredient(p_ingid) THEN
    RAISE e_ingiderror;
    ELSE
    DELETE FROM INGREDIENTS WHERE INGREDIENT_ID=p_ingid;
    END IF;

EXCEPTION

    WHEN e_ingiderror THEN
    DBMS_OUTPUT.PUT_LINE('The Ingredient ID you have entered is invalid. Please review your data and re enter the info.');

END del_INGREDIENTS;


PROCEDURE del_RECIPES(p_recipeid IN RECIPES.RECIPE_ID%TYPE) IS
e_recipeiderror            EXCEPTION;

BEGIN

    IF validators.chk_recipe_id(p_recipeid) THEN
    RAISE e_recipeiderror;
    ELSE
    DELETE FROM RECIPES WHERE RECIPE_ID=p_recipeid;
    END IF;

EXCEPTION

    WHEN e_recipeiderror THEN
    DBMS_OUTPUT.PUT_LINE('The Recipe ID you have entered is invalid. Please review your data and re enter the info.');

END del_RECIPES;

END delete_rec;


--27) Trigger sets off when there is an update in stock on the ingredients table it check to see if the stock has less then 20 oz/units and prints the ingredients that does

create or replace TRIGGER stock_chk AFTER UPDATE OF STOCK ON INGREDIENTS
BEGIN
    DECLARE
        CURSOR cur_recipe IS 
        select STOCK, INGREDIENT_NAME
        from ingredients;
        type t_stock is table of INGREDIENTS.STOCK%type
        index by binary_integer;
        type t_ing is table of INGREDIENTS.INGREDIENT_NAME%type
        index by binary_integer;
        v_stock                  t_stock;
        v_ing                    t_ing;
        V_C_count   NUMBER :=0;
    BEGIN
        FOR V_REC IN cur_recipe LOOP 
            V_C_count:=V_C_count+1;
            v_stock(V_C_count):=V_REC.STOCK;
            v_ing(V_C_count):=V_REC.INGREDIENT_NAME;
        END LOOP;
        FOR i IN 1..v_stock.count LOOP
            IF v_stock(i)<20 THEN
                DBMS_OUTPUT.PUT_LINE(v_ing(i)||' has: '||v_stock(i)|| ' which is less than 20 oz/units in stock please purchase more'|| chr(10));
            END IF;
        END LOOP;
    END;
END;



--28) create new order items record

CREATE OR REPLACE PROCEDURE new_ORDER_ITEMS(p_orderstarrate IN ORDER_ITEMS.ORDER_ITEM_STAR_RATING%TYPE, 
                                            p_ordercost IN ORDER_ITEMS.ORDER_ITEMCOST%TYPE, 
                                            p_orderid IN ORDER_ITEMS.ORDER_ID%TYPE, 
                                            p_recipe IN ORDER_ITEMS.RECIPE_ID%type) IS
e_ORDERIDerror EXCEPTION;
e_RECIPEIDerror EXCEPTION;
v_code NUMBER;
v_msg VARCHAR2(100);

BEGIN

    IF validators.chk_recipe_id(p_recipe) THEN
    RAISE e_RECIPEIDerror;

    ELSIF validators.chk_ORDER(p_orderid) THEN
    RAISE e_ORDERIDerror;

    ELSE 
    INSERT INTO ORDER_ITEMS(ORDER_ITEM_ID, ORDER_ITEM_STAR_RATING, ORDER_ITEMCOST, ORDER_ID, RECIPE_ID)
    VALUES(ORDER_ITEM_ID_SEQ.nextval, p_orderstarrate, p_ordercost, p_orderid, p_recipe);

    END IF;

EXCEPTION

    WHEN e_RECIPEIDerror THEN
    DBMS_OUTPUT.PUT_LINE('The Recipe ID you have entered is invalid. Please review your data and re enter the info.');

    WHEN e_ORDERIDerror THEN
    DBMS_OUTPUT.PUT_LINE('The Order ID you have entered is invalid. Please review your data and re enter the info.');


    WHEN others THEN
    v_code := sqlcode;
    v_msg := sqlerrm;
    DBMS_OUTPUT.PUT_LINE('An error occurred when executing'|| chr(10)||v_code|| chr(10) || v_msg);

END new_ORDER_ITEMS;


new_ORDER_ITEMS(5, 50, 16, 3);

delete_rec.del_ORDER_ITEMS(106);


select ORDER_ITEM_ID,	ORDER_ITEM_STAR_RATING,	ORDER_ITEMCOST,	ORDER_ID,	RECIPE_ID
from ORDER_ITEMS
where ORDER_ID=16 and	RECIPE_ID=3;
