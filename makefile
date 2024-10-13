BIN_LIB=DEV
APP_BNDDIR=APP
LIBL=$(BIN_LIB)

INCDIR=""
BNDDIR=($(BIN_LIB)/$(APP_BNDDIR))
PREPATH=/QSYS.LIB/$(BIN_LIB).LIB
SHELL=/QOpenSys/usr/bin/qsh

all: .logs .evfevent library $(PREPATH)/$(APP_BNDDIR).BNDDIR $(PREPATH)/POPDEPT.PGM $(PREPATH)/PROCPAY.PGM $(PREPATH)/DEPTS.PGM $(PREPATH)/EMPLOYEES.PGM $(PREPATH)/MYPGM.PGM $(PREPATH)/NEWDEPT.PGM $(PREPATH)/NEWEMP.PGM

$(PREPATH)/XDEPT3.FILE: $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/XDEPT1.FILE: $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/XDEPT2.FILE: $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/XEMP1.FILE: $(PREPATH)/EMPLOYEE.FILE
$(PREPATH)/XEMP2.FILE: $(PREPATH)/EMPLOYEE.FILE
$(PREPATH)/XPAY2.FILE: $(PREPATH)/PAYOUT.FILE
$(PREPATH)/XPAY1.FILE: $(PREPATH)/PAYOUT.FILE
$(PREPATH)/POPDEPT.PGM: $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/PROCPAY.PGM: $(PREPATH)/PAYOUT.FILE
$(PREPATH)/DEPTS.PGM: $(PREPATH)/DEPARTMENT.FILE $(PREPATH)/DEPTS.FILE
$(PREPATH)/EMPLOYEES.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/EMPS.FILE
$(PREPATH)/NEWDEPT.PGM: $(PREPATH)/DEPARTMENT.FILE $(PREPATH)/NDEPT.FILE
$(PREPATH)/NEWEMP.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/NEMP.FILE
$(PREPATH)/UNITTEST.SRVPGM: $(PREPATH)/UNITTEST.MODULE
$(PREPATH)/$(APP_BNDDIR).BNDDIR: $(PREPATH)/UNITTEST.SRVPGM

.logs:
	mkdir .logs
.evfevent:
	mkdir .evfevent
library:
	-system -q "CRTLIB LIB($(BIN_LIB))"


$(PREPATH)/MYPGM.PGM: qrpglesrc/mypgm.pgm.rpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTBNDRPG PGM($(BIN_LIB)/MYPGM) SRCSTMF('qrpglesrc/mypgm.pgm.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTRLS(*CURRENT) TGTCCSID(*JOB) BNDDIR($(BNDDIR)) DFTACTGRP(*NO)" > .logs/mypgm.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/MYPGM.MBR') TOSTMF('.evfevent/mypgm.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')

$(PREPATH)/DEPTS.PGM: qrpglesrc/depts.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/DEPTS) SRCSTMF('qrpglesrc/depts.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(BNDDIR)) DFTACTGRP(*no)')" > .logs/depts.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/DEPTS.MBR') TOSTMF('.evfevent/depts.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/EMPLOYEES.PGM: qrpglesrc/employees.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/EMPLOYEES) SRCSTMF('qrpglesrc/employees.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(BNDDIR)) DFTACTGRP(*no)')" > .logs/employees.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPLOYEES.MBR') TOSTMF('.evfevent/employees.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NEWDEPT.PGM: qrpglesrc/newdept.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/NEWDEPT) SRCSTMF('qrpglesrc/newdept.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(BNDDIR)) DFTACTGRP(*no)')" > .logs/newdept.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEWDEPT.MBR') TOSTMF('.evfevent/newdept.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NEWEMP.PGM: qrpglesrc/newemp.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/NEWEMP) SRCSTMF('qrpglesrc/newemp.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(BNDDIR)) DFTACTGRP(*no)')" > .logs/newemp.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEWEMP.MBR') TOSTMF('.evfevent/newemp.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')

$(PREPATH)/UNITTEST.MODULE: qrpglesrc/unittest.rpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTRPGMOD MODULE($(BIN_LIB)/UNITTEST) SRCSTMF('qrpglesrc/unittest.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTRLS(*CURRENT) TGTCCSID(*JOB)" > .logs/unittest.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/UNITTEST.MBR') TOSTMF('.evfevent/unittest.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')



$(PREPATH)/DEPTS.FILE: qddssrc/depts.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/depts.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/DEPTS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/DEPTS) SRCFILE($(BIN_LIB)/qddssrc) SRCMBR(DEPTS) OPTION(*EVENTF)" > .logs/depts.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/DEPTS.MBR') TOSTMF('.evfevent/depts.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/EMPS.FILE: qddssrc/emps.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/emps.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/EMPS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/EMPS) SRCFILE($(BIN_LIB)/qddssrc) SRCMBR(EMPS) OPTION(*EVENTF)" > .logs/emps.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPS.MBR') TOSTMF('.evfevent/emps.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NDEPT.FILE: qddssrc/ndept.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/ndept.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/NDEPT.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/NDEPT) SRCFILE($(BIN_LIB)/qddssrc) SRCMBR(NDEPT) OPTION(*EVENTF)" > .logs/ndept.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NDEPT.MBR') TOSTMF('.evfevent/ndept.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NEMP.FILE: qddssrc/nemp.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/nemp.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/NEMP.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/NEMP) SRCFILE($(BIN_LIB)/qddssrc) SRCMBR(NEMP) OPTION(*EVENTF)" > .logs/nemp.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEMP.MBR') TOSTMF('.evfevent/nemp.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')





$(PREPATH)/DEPARTMENT.FILE: qddssrc/department.table
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/department.table') COMMIT(*NONE)" > .logs/department.splf
$(PREPATH)/EMPLOYEE.FILE: qddssrc/employee.table
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/employee.table') COMMIT(*NONE)" > .logs/employee.splf
$(PREPATH)/PAYOUT.FILE: qddssrc/payout.table
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/payout.table') COMMIT(*NONE)" > .logs/payout.splf


$(PREPATH)/UNITTEST.SRVPGM: qsrvsrc/unittest.bnd
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$(APP_BNDDIR))"
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ((*LIBL/RUTESTCASE *SRVPGM *IMMED))"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSRVPGM SRVPGM($(BIN_LIB)/UNITTEST) MODULE(UNITTEST) SRCSTMF('qsrvsrc/unittest.bnd') BNDDIR($(BNDDIR)) OPTION(*DUPPROC) REPLACE(*YES)" > .logs/unittest.splf
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ((*LIBL/UNITTEST *SRVPGM *IMMED))"


$(PREPATH)/%.BNDDIR: 
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$*)"
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$*) OBJ($(patsubst %.SRVPGM,(*LIBL/% *SRVPGM *IMMED),$(notdir $^)))"





$(PREPATH)/XDEPT3.FILE: qddssrc/department_admrdept.index
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/department_admrdept.index') COMMIT(*NONE)" > .logs/xdept3.splf
$(PREPATH)/XDEPT1.FILE: qddssrc/department_deptno.index
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/department_deptno.index') COMMIT(*NONE)" > .logs/xdept1.splf
$(PREPATH)/XDEPT2.FILE: qddssrc/department_mgrno.index
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/department_mgrno.index') COMMIT(*NONE)" > .logs/xdept2.splf
$(PREPATH)/XEMP1.FILE: qddssrc/employee_empno.index
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/employee_empno.index') COMMIT(*NONE)" > .logs/xemp1.splf
$(PREPATH)/XEMP2.FILE: qddssrc/employee_workdept.index
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/employee_workdept.index') COMMIT(*NONE)" > .logs/xemp2.splf
$(PREPATH)/XPAY2.FILE: qddssrc/payout_empno.index
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/payout_empno.index') COMMIT(*NONE)" > .logs/xpay2.splf
$(PREPATH)/XPAY1.FILE: qddssrc/payout_payoutno.index
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qddssrc/payout_payoutno.index') COMMIT(*NONE)" > .logs/xpay1.splf
