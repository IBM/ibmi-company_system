create or replace procedure cmpsys.popemp()
P1: BEGIN
    declare v_url CLOB(10M);
    declare v_response CLOB(10M);
    declare v_dept_name varchar(36);
    declare v_mgr_no char(6);
    declare v_admr_dept char(3);
    declare v_location char(16);
    declare v_emp_no char(6);
    declare v_first_name varchar(12);
    declare v_mid_init char(1);
    declare v_last_name varchar(15);
    declare v_work_dept char(3);
    declare v_phone_no char(4);
    declare v_hire_date date;
    declare v_job char(8);
    declare v_ed_level SMALLint;
    declare v_sex char(1);
    declare v_birth_date date;
    declare v_salary decimal(9,2);
    declare v_bonus decimal(9,2);
    declare v_comm decimal(9,2);
    declare i int default 1;



    
    -- Populate EMPLOYEE table
    while i <= 200 DO
        set v_url = 'https://randomuser.me/api/?nat=in';
        set v_response = SYSTOOLS.HTTPGETCLOB(v_url, NULL);
        set v_emp_no = i;
        set v_first_name = json_value(v_response, '$.results[0].name.first');
        set v_mid_init = substr(json_value(v_response, '$.results[0].name.first'), 1, 1);
        set v_last_name = json_value(v_response, '$.results[0].name.last');
        
        -- Assign a random department from DEPARTMENT table
        select  deptno
        into    v_work_dept
        from    department
        order by rand()
        fetch   first row only;
        
        set v_phone_no = substr(HEX(rand()), 1, 4);
        set v_hire_date = date('2023-01-01') + int(rand() * 365 * 10) DAYS;
        set v_job = 'JOB' || substr(HEX(rand()), 1, 4);
        set v_ed_level = 12 + int(rand() * 8);
        set v_sex = substr(json_value(v_response, '$.results[0].gender'),1,1);
        set v_birth_date = date('1960-01-01') + int(rand() * 365 * 50) DAYS;
        set v_salary = decimal(30000 + rand() * 70000, 9, 2);
        set v_bonus = decimal(rand() * 10000, 9, 2);
        set v_comm = decimal(rand() * 5000, 9, 2);

        
        insert into EMPLOYEE 
        (EMPNO, FIRSTNME, MIDINIT, LASTNAME, WORKDEPT, PHONENO, HIREdate, JOB, EDLEVEL, SEX, BIRTHdate, SALARY, BONUS, COMM)
        VALUES (v_emp_no, v_first_name, v_mid_init, v_last_name, v_work_dept, v_phone_no, v_hire_date, v_job, v_ed_level, 
        v_sex, v_birth_date, v_salary, v_bonus, v_comm);
        
        set i = i + 1;
        
    end while;
end P1;
