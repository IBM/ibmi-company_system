EMPDET.MODULE: empdet.sqlrpgle EMPLOYEE.FILE DEPARTMENT.FILE
EMPDET.SRVPGM: empdet.bnd EMPDET.MODULE
APP.BNDDIR: app.bnddir EMPDET.SRVPGM
EMPLOYEES.PGM: employees.pgm.sqlrpgle APP.BNDDIR EMPLOYEE.FILE EMPS.FILE
DEPTS.PGM: depts.pgm.sqlrpgle EMPLOYEES.PGM NEWEMP.PGM DEPARTMENT.FILE DEPTS.FILE
NEWEMP.PGM: newemp.pgm.sqlrpgle EMPLOYEE.FILE NEMP.FILE
MYPGM.PGM: mypgm.pgm.rpgle