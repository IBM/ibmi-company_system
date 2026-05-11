**free

Ctl-Opt DFTACTGRP(*NO);

//---------------------------------------------------------------*

/include 'qrpgleref/constants.rpgleinc'

//---------------------------------------------------------------*

dcl-f newdept workstn indDs(WkStnInd) infDs(FileInfo);

Dcl-S Exit Ind Inz(*Off);

Dcl-DS WkStnInd;
  F3         Ind   Pos(03);
  F5         Ind   Pos(05);
  Error      Ind   Pos(25);
End-DS;


Dcl-DS FileInfo;
  FunKey Char(1) Pos(369);
End-DS;

//---------------------------------------------------------------*


Dcl-S Msg Char(50);

//---------------------------------------------------------------*


// Main logic
Exit = *Off;
ClearScreen();

Dow (Not Exit);
  Write HEADER_FMT;
  Exfmt DETAIL;

  Select;
    When (F3);
      Exit = *On;
    Other;
      HandleAdd();
  Endsl;
Enddo;

*INLR = *ON;
Return;

// --------------------------------------------------------------

Dcl-Proc ClearScreen;
  Clear XID;
  Clear XDEPT;
  Msg = *Blanks;
End-Proc;

Dcl-Proc HandleAdd;
  // Use display file fields XID and XDEPT for department number and name
  If (%Trim(XID) = '' or %Trim(XDEPT) = '');
    Msg = 'Department number and name required.';
    Return;
  Endif;

  Exec SQL
    Insert Into DEPARTMENT (DEPTNO, DEPTNAME)
    Values (:XID, :XDEPT);

  If (SQLCODE = 0);
    Msg = 'Department added successfully.';
    Clear XID;
    Clear XDEPT;
    Exit = *On;
  Else;
    Msg = 'Error adding department: ' + %Char(SQLCODE);
  Endif;
End-Proc;
