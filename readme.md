## Company System

Company System is a demo application that works with three build tools:

* GNU Make
* [ibmi-bob](https://ibm.github.io/ibmi-bob/#/)
* ARCAD Builder from IBM i Modernization Engine for Lifecycle Integration (Merlin)

#### Object list
| Object     | Type     | Description                   
| ---------- | -------- | ---------------------------------- 
| employee   | PF       | An SQL table to hold the employee records
| departmnet | PF       | An SQL table to hold the department records
| popdept    | SQLPRC   | An SQL Stored procedure to auto populate department records
| popemp     | SQLPRC   | An SQL Stored procedure to auto populate employee records
| emps       | DSPF     | Display file for Employee maintenance
| depts      | DSPF     | Display file for Department maintenance
| depts      | SQLRPGLE | Department maintenance program
| employees  | SQLRPGLE | Employee maintenance program


### Setup
1. Open the SHELL and Install IBMi Repos & BOB 
```
yum install ibmi-repos bob
```
2. Create a library to save the build 
```
cl "CRTLIB LIB(CMPSYS) TEXT('Better Object Builder test project')"
```
3. Clone the repository 
```
git clone https://github.com/IBM/ibmi-company_system
```

4. Navigate to the cloned repo directory & set the environment variable to point the library that we just created
```
cd ibmi-company_system && export CURLIB=CMPSYS
```

5. Run the build using 
```
makei build
```


### Build Commands

* GNU Make
* ibmi-bob
   * Project build `makei build`
   * Compile of files `makei compile -f {files}`
* ARCAD Builder
   * Project build `/QOpenSys/pkgs/bin/elias compile {branch}`
   * Compile of files `/QOpenSys/pkgs/bin/elias compile {branch} -f {files}`
