BIN_LIB=DEV
APP_BNDDIR=APP
LIBL=$(BIN_LIB)

INCDIR=""
BNDDIR=*NONE
PREPATH=/QSYS.LIB/$(BIN_LIB).LIB
SHELL=/QOpenSys/usr/bin/qsh

all: .logs .evfevent library $(PREPATH)/POPDEPT.PGM $(PREPATH)/DEPTS.PGM $(PREPATH)/EMPLOYEES.PGM $(PREPATH)/MYPGM.PGM $(PREPATH)/NEWEMP.PGM

$(PREPATH)/POPDEPT.PGM: $(PREPATH)/DEPARTMENT.FILE
$(PREPATH)/DEPTS.PGM: $(PREPATH)/DEPARTMENT.FILE $(PREPATH)/DEPTS.FILE
$(PREPATH)/EMPLOYEES.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/EMPS.FILE
$(PREPATH)/NEWEMP.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/NEMP.FILE

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
$(PREPATH)/NEWEMP.PGM: qrpglesrc/newemp.pgm.sqlrpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/NEWEMP) SRCSTMF('qrpglesrc/newemp.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) RPGPPOPT(*LVL2) COMPILEOPT('TGTCCSID(*JOB) BNDDIR($(BNDDIR)) DFTACTGRP(*no)')" > .logs/newemp.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/NEWEMP.MBR') TOSTMF('.evfevent/newemp.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')

$(PREPATH)/TEST.MODULE: qrpglesrc/test.rpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTRPGMOD MODULE($(BIN_LIB)/TEST) SRCSTMF('qrpglesrc/test.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTRLS(*CURRENT) TGTCCSID(*JOB)" > .logs/test.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/TEST.MBR') TOSTMF('.evfevent/test.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')



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




$(PREPATH)/%.BNDDIR: 
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$*)"
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$*) OBJ($(patsubst %.SRVPGM,(*LIBL/% *SRVPGM *IMMED),$(notdir $^)))"





