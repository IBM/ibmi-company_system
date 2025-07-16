**free

ctl-opt nomain ccsidcvt(*excp) ccsid(*char : *jobrun) BNDDIR('APP');

/include qinclude,TESTCASE
/include 'qrpgleref/empdet.rpgleinc'

exec sql
  set option commit = *none;

dcl-proc setUpSuite export;
  // Insert sample data into employee
  exec sql
    insert into employee (
      empno, firstnme, midinit, lastname, workdept, phoneno,
      hiredate, job, edlevel, sex, birthdate, salary, bonus, comm
    ) values 
      (
        '000010', 'CHRISTINE', 'I', 'HAAS', 'A00', '3978', null,
        'PRES', 18, 'F', null, 52750, 1000, 4220
      ),
      (
        '000020', 'MICHAEL', 'L', 'THOMPSON', 'B01', '3476', null,
        'MANAGER', 18, 'M', null, 41250, 800, 3300
        ),
      (
        '200120', 'GREG', '', 'ORLANDO', 'A00', '2167', null,
        'CLERK', 14, 'M', null, 29250, 600, 2340
      );
  
  if (sqlcode <> 0 and sqlcode <> -803);
    fail('Failed to insert into employee table with SQL code: ' + %char(sqlcode));
  endif;

  // Insert sample data in department table
  exec sql
    insert into department (
      deptno, deptname, mgrno, admrdept, location
    ) values
      ('A00', 'SPIFFY COMPUTER SERVICE DIV.', '000010', 'A00', 'NEW YORK'),
      ('B01', 'PLANNING', '000020', 'A00', 'ATLANTA');

  if (sqlcode <> 0 and sqlcode <> -803);
    fail('Failed to insert into department table with SQL code: ' + %char(sqlcode));
  endif;
end-proc;

dcl-proc test_getEmployeeDetail_found export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s empno char(6);
  dcl-ds actual likeDs(employee_detail_t) inz;
  dcl-ds expected likeDs(employee_detail_t) inz;

  empno = '000010';
  actual = getEmployeeDetail(empno);

  expected.found = *on;
  expected.name = 'CHRISTINE I HAAS';
  expected.netincome = 52750 + 1000 + 4220;

  nEqual(expected.found : actual.found : 'found');
  assert(expected.name = actual.name : 'name');
  assert(expected.netincome = actual.netincome : 'netincome');
end-proc;

dcl-proc test_getEmployeeDetail_notFound export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s empno char(6);
  dcl-ds actual likeDs(employee_detail_t) inz;
  dcl-ds expected likeDs(employee_detail_t) inz;

  empno = '11111';

  actual = getEmployeeDetail(empno);

  expected.found = *off;

  nEqual(expected.found : actual.found : 'found');
end-proc;

dcl-proc test_getDeptDetail_found export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s deptno char(3);
  dcl-ds actual likeDs(department_detail_t) inz;
  dcl-ds expected likeDs(department_detail_t) inz;

  deptno = 'A00';
  actual = getDeptDetail(deptno);

  expected.found = *on;
  expected.deptname = 'SPIFFY COMPUTER SERVICE DIV.';
  expected.location = 'NEW YORK';
  expected.totalsalaries = 90160;

  nEqual(expected.found : actual.found : 'found');
  assert(expected.deptname = actual.deptname : 'deptname');
  assert(expected.location = actual.location : 'location');
  assert(expected.totalsalaries = actual.totalsalaries : 'totalsalaries');
end-proc;

dcl-proc test_getDeptDetail_notFound export;
  dcl-pi *n extproc(*dclcase) end-pi;

  dcl-s deptno char(3);
  dcl-ds actual likeDs(department_detail_t) inz;
  dcl-ds expected likeDs(department_detail_t) inz;

  deptno = 'AAA';
  actual = getDeptDetail(deptno);

  expected.found = *off;

  nEqual(expected.found : actual.found : 'found');
end-proc;