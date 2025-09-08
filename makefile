BIN_LIB=DEV
APP_BNDDIR=APP
LIBL=$(BIN_LIB)

INCDIR=""
BNDDIR=($(BIN_LIB)/$(APP_BNDDIR))
PREPATH=/QSYS.LIB/$(BIN_LIB).LIB
SHELL=/QOpenSys/usr/bin/qsh

all: .logs .evfevent library $(PREPATH)/APP.BNDDIR $(PREPATH)/DEPTS.PGM $(PREPATH)/POPDEPT.PGM $(PREPATH)/POPEMP.PGM $(PREPATH)/EMPLOYEES.PGM $(PREPATH)/MYPGM.PGM $(PREPATH)/NEWEMP.PGM

$(PREPATH)/EMPDET.SRVPGM: $(PREPATH)/EMPDET.MODULE
$(PREPATH)/EMPDET.MODULE: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/DEPTS.PGM: $(PREPATH)/EMPLOYEES.PGM $(PREPATH)/NEWEMP.PGM $(PREPATH)/DEPARTMENT.FILE $(PREPATH)/DEPTS.FILE
$(PREPATH)/POPDEPT.PGM: $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/POPEMP.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/EMPLOYEES.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/EMPS.FILE
$(PREPATH)/NEWEMP.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/NEMP.FILE
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
	system "CRTBNDRPG PGM($(BIN_LIB)/MYPGM) SRCSTMF('qrpglesrc/mypgm.pgm.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTRLS(*CURRENT) TGTCCSID(*JOB) BNDDIR($(APP_BNDDIR)) DFTACTGRP(*NO)" > .logs/mypgm.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/MYPGM.MBR') TOSTMF('.evfevent/mypgm.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')

$(PREPATH)/DEPTS.PGM: qrpglesrc/depts.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/DEPTS) SRCSTMF('qrpglesrc/depts.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(APP_BNDDIR)) DFTACTGRP(*no)')" > .logs/depts.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/DEPTS.MBR') TOSTMF('.evfevent/depts.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/EMPLOYEES.PGM: qrpglesrc/employees.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/EMPLOYEES) SRCSTMF('qrpglesrc/employees.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(APP_BNDDIR)) DFTACTGRP(*no)')" > .logs/employees.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPLOYEES.MBR') TOSTMF('.evfevent/employees.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NEWEMP.PGM: qrpglesrc/newemp.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/NEWEMP) SRCSTMF('qrpglesrc/newemp.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(APP_BNDDIR)) DFTACTGRP(*no)')" > .logs/newemp.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEWEMP.MBR') TOSTMF('.evfevent/newemp.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')


$(PREPATH)/EMPDET.MODULE: qrpglesrc/empdet.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/EMPDET) SRCSTMF('qrpglesrc/empdet.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) COMPILEOPT('TGTCCSID(*JOB)') RPGPPOPT(*LVL2) OPTION(*EVENTF) OBJTYPE(*MODULE)" > .logs/empdet.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPDET.MBR') TOSTMF('.evfevent/empdet.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/TEMPDET.MODULE: qtestsrc/empdet.test.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/TEMPDET) SRCSTMF('qtestsrc/empdet.test.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) COMPILEOPT('TGTCCSID(*JOB)') RPGPPOPT(*LVL2) OPTION(*EVENTF) OBJTYPE(*MODULE)" > .logs/tempdet.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/TEMPDET.MBR') TOSTMF('.evfevent/tempdet.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')


$(PREPATH)/DEPTS.FILE: qddssrc/depts.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/QTMPSRC) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/depts.dspf') TOMBR('$(PREPATH)/QTMPSRC.FILE/DEPTS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/DEPTS) SRCFILE($(BIN_LIB)/QTMPSRC) SRCMBR(DEPTS) OPTION(*EVENTF)" > .logs/depts.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/DEPTS.MBR') TOSTMF('.evfevent/depts.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/EMPS.FILE: qddssrc/emps.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/QTMPSRC) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/emps.dspf') TOMBR('$(PREPATH)/QTMPSRC.FILE/EMPS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/EMPS) SRCFILE($(BIN_LIB)/QTMPSRC) SRCMBR(EMPS) OPTION(*EVENTF)" > .logs/emps.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/EMPS.MBR') TOSTMF('.evfevent/emps.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
$(PREPATH)/NEMP.FILE: qddssrc/nemp.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/QTMPSRC) RCDLEN(112) CCSID(*JOB)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/nemp.dspf') TOMBR('$(PREPATH)/QTMPSRC.FILE/NEMP.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTDSPF FILE($(BIN_LIB)/NEMP) SRCFILE($(BIN_LIB)/QTMPSRC) SRCMBR(NEMP) OPTION(*EVENTF)" > .logs/nemp.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEMP.MBR') TOSTMF('.evfevent/nemp.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')





$(PREPATH)/EMPLOYEE.FILE: qsqlsrc/employee.table
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qsqlsrc/employee.table') COMMIT(*NONE)" > .logs/employee.splf
$(PREPATH)/DEPARTMENT.FILE: qsqlsrc/department.table
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUNSQLSTM SRCSTMF('qsqlsrc/department.table') COMMIT(*NONE)" > .logs/department.splf


$(PREPATH)/EMPDET.SRVPGM: qrpglesrc/empdet.bnd
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$(APP_BNDDIR))"
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSRVPGM SRVPGM($(BIN_LIB)/EMPDET) MODULE(EMPDET) SRCSTMF('qrpglesrc/empdet.bnd') BNDDIR($(BNDDIR)) REPLACE(*YES)" > .logs/empdet.splf
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ((*LIBL/EMPDET *SRVPGM *IMMED))"






