DEPTS.PGM: depts.pgm.sqlrpgle qrpgleref/constants.rpgleinc EMPLOYEES.PGM NEWEMP.PGM DEPARTMENT.FILE DEPTS.FILE
EMPDET.SRVPGM: empdet.bnd EMPDET.MODULE
EMPDET.MODULE: empdet.sqlrpgle qrpgleref/empdet.rpgleinc EMPLOYEE.FILE DEPARTMENT.FILE
EMPLOYEES.PGM: employees.pgm.sqlrpgle qrpgleref/constants.rpgleinc qrpgleref/empdet.rpgleinc EMPLOYEE.FILE EMPS.FILE APP.BNDDIR
MYPGM.PGM: mypgm.pgm.rpgle qrpgleref/constants.rpgleinc
NEWEMP.PGM: newemp.pgm.sqlrpgle qrpgleref/constants.rpgleinc EMPLOYEE.FILE NEMP.FILE
APP.BNDDIR: app.bnddir EMPDET.SRVPGM