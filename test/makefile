BIN_LIB=DEV
RPGUNIT_LIB=RPGUNIT
LIBL=$(BIN_LIB) $(RPGUNIT_LIB)
SHELL=/QOpenSys/usr/bin/qsh

all:

all: .logs .evfevent library test.rpgle

.logs:
	mkdir .logs
.evfevent:
	mkdir .evfevent
library:
	-system -q "CRTLIB LIB($(BIN_LIB))"

test.rpgle: qrpglesrc/test.rpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTRPGMOD MODULE($(BIN_LIB)/TEST) SRCSTMF('qrpglesrc/test.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTRLS(*CURRENT) TGTCCSID(*JOB)" > .logs/test.splf || \
	(system "CPYTOSTMF FROMMBR('$(PREPATH)/EVFEVENT.FILE/TEST.MBR') TOSTMF('.evfevent/test.evfevent') DBFCCSID(*FILE) STMFCCSID(1208) STMFOPT(*REPLACE)"; $(SHELL) -c 'exit 1')
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "CRTSRVPGM SRVPGM($(BIN_LIB)/TEST) MODULE($(BIN_LIB)/TEST) BNDSRVPGM(RUTESTCASE) EXPORT(*ALL) OPTION(*DUPPROC) REPLACE(*YES)" > .logs/test.splf
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUCALLTST TSTPGM($(BIN_LIB)/TEST) XMLSTMF('./test/TEST-report.xml')"
