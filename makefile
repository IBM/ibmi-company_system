BIN_LIB=DEV
APP_BNDDIR=APP

INCDIR=""
BNDDIR=($(BIN_LIB)/$(APP_BNDDIR))
PREPATH=/QSYS.LIB/$(BIN_LIB).LIB
SHELL=/QOpenSys/usr/bin/qsh

all: $(PREPATH)/$(APP_BNDDIR).BNDDIR $(PREPATH)/DEPTS.PGM $(PREPATH)/EMPLOYEES.PGM $(PREPATH)/MYPGM.PGM

$(PREPATH)/DEPTS.PGM: $(PREPATH)/EMPLOYEES.PGM $(PREPATH)/DEPARTMENT.FILE $(PREPATH)/DEPTS.FILE $(PREPATH)/UTILS.SRVPGM
$(PREPATH)/EMPLOYEES.PGM: $(PREPATH)/EMPLOYEE.FILE $(PREPATH)/EMPS.FILE
$(PREPATH)/UTILS.SRVPGM: $(PREPATH)/UTILS.MODULE
$(PREPATH)/$(APP_BNDDIR).BNDDIR: $(PREPATH)/UTILS.SRVPGM $(PREPATH)/BANKING.SRVPGM
$(PREPATH)/BANKING.SRVPGM: $(PREPATH)/BANKING.MODULE

$(PREPATH)/MYPGM.PGM: qrpglesrc/mypgm.pgm.rpgle
	liblist -c $(BIN_LIB);\
	system "CRTBNDRPG PGM($(BIN_LIB)/MYPGM) SRCSTMF('qrpglesrc/mypgm.pgm.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTRLS(*CURRENT) TGTCCSID(*JOB) BNDDIR($(BNDDIR)) DFTACTGRP(*no)"

$(PREPATH)/DEPTS.PGM: qrpglesrc/depts.pgm.sqlrpgle
	system -s "CHGATR OBJ('qrpglesrc/depts.pgm.sqlrpgle') ATR(*CCSID) VALUE(1252)"
	liblist -c $(BIN_LIB);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/DEPTS) SRCSTMF('qrpglesrc/depts.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) COMPILEOPT('BNDDIR($(BNDDIR)) DFTACTGRP(*no)')"
$(PREPATH)/EMPLOYEES.PGM: qrpglesrc/employees.pgm.sqlrpgle
	system -s "CHGATR OBJ('qrpglesrc/employees.pgm.sqlrpgle') ATR(*CCSID) VALUE(1252)"
	liblist -c $(BIN_LIB);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/EMPLOYEES) SRCSTMF('qrpglesrc/employees.pgm.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) COMPILEOPT('BNDDIR($(BNDDIR)) DFTACTGRP(*no)')"

$(PREPATH)/BANKING.MODULE: qrpglesrc/banking.sqlrpgle
	system -s "CHGATR OBJ('qrpglesrc/banking.sqlrpgle') ATR(*CCSID) VALUE(1252)"
	liblist -c $(BIN_LIB);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/BANKING) SRCSTMF('qrpglesrc/banking.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) OBJTYPE(*MODULE)"
$(PREPATH)/UTILS.MODULE: qrpglesrc/utils.sqlrpgle
	system -s "CHGATR OBJ('qrpglesrc/utils.sqlrpgle') ATR(*CCSID) VALUE(1252)"
	liblist -c $(BIN_LIB);\
	system "CRTSQLRPGI OBJ($(BIN_LIB)/UTILS) SRCSTMF('qrpglesrc/utils.sqlrpgle') COMMIT(*NONE) DBGVIEW(*SOURCE) OPTION(*EVENTF) OBJTYPE(*MODULE)"


$(PREPATH)/DEPTS.FILE: qddssrc/depts.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/depts.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/DEPTS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	system "CRTDSPF FILE($(BIN_LIB)/DEPTS) SRCFILE($(BIN_LIB)/qddssrc) SRCMBR(DEPTS) OPTION(*EVENTF)"
$(PREPATH)/EMPS.FILE: qddssrc/emps.dspf
	-system -qi "CRTSRCPF FILE($(BIN_LIB)/qddssrc) RCDLEN(112)"
	system "CPYFRMSTMF FROMSTMF('qddssrc/emps.dspf') TOMBR('$(PREPATH)/qddssrc.FILE/EMPS.MBR') MBROPT(*REPLACE)"
	liblist -c $(BIN_LIB);\
	system "CRTDSPF FILE($(BIN_LIB)/EMPS) SRCFILE($(BIN_LIB)/qddssrc) SRCMBR(EMPS) OPTION(*EVENTF)"




$(PREPATH)/DEPARTMENT.FILE: qddssrc/department.table
	liblist -c $(BIN_LIB);\
	system "RUNSQLSTM SRCSTMF('qddssrc/department.table') COMMIT(*NONE)"
$(PREPATH)/EMPLOYEE.FILE: qddssrc/employee.table
	liblist -c $(BIN_LIB);\
	system "RUNSQLSTM SRCSTMF('qddssrc/employee.table') COMMIT(*NONE)"


$(PREPATH)/UTILS.SRVPGM: qsrvsrc/utils.bnd
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$(APP_BNDDIR))"
	-system -q "RMVBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ(($(BIN_LIB)/UTILS))"
	-system "DLTOBJ OBJ($(BIN_LIB)/UTILS) OBJTYPE(*SRVPGM)"
	liblist -c $(BIN_LIB);\
	system "CRTSRVPGM SRVPGM($(BIN_LIB)/UTILS) MODULE(UTILS) SRCSTMF('qsrvsrc/utils.bnd') BNDDIR($(BNDDIR))"
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ((*LIBL/UTILS *SRVPGM *IMMED))"

$(PREPATH)/%.SRVPGM: 
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$(APP_BNDDIR))"
	-system -q "RMVBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ(($(BIN_LIB)/$*))"
	-system "DLTOBJ OBJ($(BIN_LIB)/$*) OBJTYPE(*SRVPGM)"
	liblist -c $(BIN_LIB);\
	system "CRTSRVPGM SRVPGM($(BIN_LIB)/$*) MODULE(*SRVPGM) EXPORT(*ALL) BNDDIR($(BNDDIR))"
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$(APP_BNDDIR)) OBJ((*LIBL/$* *SRVPGM *IMMED))"

$(PREPATH)/%.BNDDIR: 
	-system -q "CRTBNDDIR BNDDIR($(BIN_LIB)/$*)"
	-system -q "ADDBNDDIRE BNDDIR($(BIN_LIB)/$*) OBJ($(patsubst %.SRVPGM,(*LIBL/% *SRVPGM *IMMED),$(notdir $^)))"




