BIN_LIB=DEV
RPGUNIT_LIB=RPGUNIT
LIBL=$(BIN_LIB) $(RPGUNIT_LIB)
SHELL=/QOpenSys/usr/bin/qsh

unittest.rpgle: qrpglesrc/unittest.rpgle
	liblist -c $(BIN_LIB);\
	liblist -a $(LIBL);\
	system "RUCALLTST TSTPGM($(BIN_LIB)/UNITTEST) XMLSTMF('./test/TEST-report.xml')"
