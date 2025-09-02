BIN_LIB=DEV
APP_BNDDIR=APP
LIBL=$(BIN_LIB)

INCDIR=""
BNDDIR=($(BIN_LIB)/$(APP_BNDDIR))
PREPATH=/QSYS.LIB/$(BIN_LIB).LIB
SHELL=/QOpenSys/usr/bin/qsh

$(PREPATH)/DEPTS.PGM: $(PREPATH)/EMPLOYEES.PGM $(PREPATH)/NEWEMP.PGM $(PREPATH)/DEPARTMENT.FILE $(PREPATH)/DEPTS.FILE
$(PREPATH)/EMPDET.SRVPGM: $(PREPATH)/EMPDET.MODULE
$(PREPATH)/EMPDET.MODULE: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/EMPLOYEES.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/EMPS.FILE
$(PREPATH)/NEWEMP.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/NEMP.FILE
$(PREPATH)/POPDEPT.PGM: $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/POPEMP.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/TEMPDET.MODULE: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/APP.BNDDIR: $(PREPATH)/EMPDET.SRVPGM

.logs:
	mkdir .logs
.evfevent:
	mkdir .evfevent
library:
	-system -q "CRTLIB LIB($(BIN_LIB))"


$(PREPATH)/MYPGM.PGM: qrpglesrc/mypgm.pgm.rpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTBNDRPG PGM($(BIN_LIB)/mypgm) SRCSTMF('qrpglesrc/mypgm.pgm.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTCCSID(*JOB)" > .logs/mypgm.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/MYPGM.MBR') TOSTMF('.evfevent/mypgm.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')

$(PREPATH)/DEPTS.PGM: qrpglesrc/depts.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/depts) SRCSTMF('qrpglesrc/depts.pgm.sqlrpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) CLOSQLCSR(*ENDMOD) CVTCCSID(*JOB) COMPILEOPT('TGTCCSID*JOB') RPGPPOPT(*LVL2)" > .logs/depts.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/DEPTS.MBR') TOSTMF('.evfevent/depts.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/EMPLOYEES.PGM: qrpglesrc/employees.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/employees) SRCSTMF('qrpglesrc/employees.pgm.sqlrpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) CLOSQLCSR(*ENDMOD) CVTCCSID(*JOB) COMPILEOPT('TGTCCSID*JOB') RPGPPOPT(*LVL2)" > .logs/employees.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPLOYEES.MBR') TOSTMF('.evfevent/employees.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NEWEMP.PGM: qrpglesrc/newemp.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/newemp) SRCSTMF('qrpglesrc/newemp.pgm.sqlrpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) CLOSQLCSR(*ENDMOD) CVTCCSID(*JOB) COMPILEOPT('TGTCCSID*JOB') RPGPPOPT(*LVL2)" > .logs/newemp.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEWEMP.MBR') TOSTMF('.evfevent/newemp.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')


$(PREPATH)/EMPDET.MODULE: qrpglesrc/empdet.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/empdet) SRCSTMF('qrpglesrc/empdet.sqlrpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) CLOSQLCSR(*ENDMOD) CVTCCSID(*JOB) COMPILEOPT('TGTCCSID*JOB') RPGPPOPT(*LVL2)" > .logs/empdet.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPDET.MBR') TOSTMF('.evfevent/empdet.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/TEMPDET.MODULE: qtestsrc/empdet.test.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/empdet) SRCSTMF('qtestsrc/empdet.test.sqlrpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) CLOSQLCSR(*ENDMOD) CVTCCSID(*JOB) COMPILEOPT('TGTCCSID*JOB') RPGPPOPT(*LVL2)" > .logs/tempdet.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/TEMPDET.MBR') TOSTMF('.evfevent/tempdet.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')


$(PREPATH)/DEPTS.FILE: qddssrc/depts.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/depts.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/DEPTS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/depts) SRCFILE(&SRCFILE) RSTDSP(*NO) OPTION(*EVENTF)" > .logs/depts.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/DEPTS.MBR') TOSTMF('.evfevent/depts.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/EMPS.FILE: qddssrc/emps.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/emps.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/EMPS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/emps) SRCFILE(&SRCFILE) RSTDSP(*NO) OPTION(*EVENTF)" > .logs/emps.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPS.MBR') TOSTMF('.evfevent/emps.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NEMP.FILE: qddssrc/nemp.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/nemp.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/NEMP.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/nemp) SRCFILE(&SRCFILE) RSTDSP(*NO) OPTION(*EVENTF)" > .logs/nemp.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEMP.MBR') TOSTMF('.evfevent/nemp.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')





$(PREPATH)/DEPARTMENT.FILE: qsqlsrc/department.table
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qsqlsrc/department.table') COMMIT(*NONE)" > .logs/department.splf
$(PREPATH)/EMPLOYEE.FILE: qsqlsrc/employee.table
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qsqlsrc/employee.table') COMMIT(*NONE)" > .logs/employee.splf


$(PREPATH)/EMPDET.SRVPGM: qrpglesrc/empdet.bnd
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$(APP_BNDDIR))"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSRVPGM SRVPGM($(BIN_LIB)/empdet) SRCSTMF('qrpglesrc/empdet.bnd') BNDSRVPGM(*NONE) BNDDIR(*NONE) ACTGRP(*CALLER)" > .logs/empdet.splf
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ((*LIBL/EMPDET *SRVPGM *IMMED))"






