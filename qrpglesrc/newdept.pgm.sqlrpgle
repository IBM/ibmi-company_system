**free

ctl-opt dftactgrp(*no);

dcl-pi NEWDEPT;
  deptName Char(36);
  mgrNo Char(6);
  admrDept Char(3);
  location Char(16);
end-pi;

// ---------------------------------------------------------------*

/INCLUDE 'qrpgleref/constants.rpgleinc'

// ---------------------------------------------------------------*

Dcl-F ndept WORKSTN IndDS(WkStnInd) InfDS(FILEINFO);

Dcl-S Exit Ind Inz(*Off);

Dcl-DS WkStnInd;
  ProcessSCF     Ind        Pos(21);
  ReprintScf     Ind        Pos(22);
  Error          Ind        Pos(25);
  PageDown       Ind        Pos(30);
  PageUp         Ind        Pos(31);
  SflEnd         Ind        Pos(40);
  SflBegin       Ind        Pos(41);
  NoRecord       Ind        Pos(60);
  SflDspCtl      Ind        Pos(85);
  SflClr         Ind        Pos(75);
  SflDsp         Ind        Pos(95);
End-DS;

Dcl-DS FILEINFO;
  FUNKEY         Char(1)    Pos(369);
End-DS;

Dcl-Ds Department ExtName('DEPARTMENT') Alias Qualified;
End-Ds;

Dcl-s autoDeptId char(3);
dcl-s currentError like(XERR);

autoDeptId = getNewDeptId();

if (autoDeptId = EMPTY);
  XERR = 'Unable to automatically generate a new ID.';
else;
  XDEPT = autoDeptId;
Endif;

Dow (NOT Exit);

  Write HEADER_FMT;
  Exfmt DETAIL;

  currentError = GetError();

  if (FUNKEY = F12);
    Exit = *On;

  elseif (currentError = EMPTY);
    // TODO: handle insert and exit
    
    if (HandleInsert());
      Exit = *on;
    else;
      XERR = 'Unable to create department.';
    endif;

  else;
    XERR = currentError;
  endif;

Enddo;

return;

Dcl-Proc HandleInsert;
  Dcl-Pi *N ind End-Pi;

  Dcl-ds newDept LikeDS(Department);

  newDept.DEPTNO = XDEPT;
  newDept.DEPTNAME = deptName;
  newDept.MGRNO = mgrNo;
  newDept.ADMRDEPT = admrDept;
  newDept.LOCATION = location;

  EXEC SQL
    insert into department
    values (:newDept)
    with nc;

  return (sqlstate = SQL_SUCCESS);
End-Proc;

Dcl-Proc GetError;
  Dcl-Pi *N Like(XERR) End-Pi;

  if (deptName = EMPTY);
    return 'Department name cannot be blank';
  endif;

  if (mgrNo = EMPTY);
    return 'Manager number cannot be blank';
  endif;

  if (admrDept = EMPTY);
    return 'Admin department cannot be blank';
  endif;

  if (location = EMPTY);
    return 'Location cannot be blank';
  endif;

  return EMPTY;
End-Proc;

Dcl-Proc getNewDeptId;
  Dcl-Pi *N Char(3) End-Pi;

  dcl-s result char(3);
  dcl-s asChar varchar(3);
  dcl-s startI int(3);
  Dcl-s highestDeptId int(10);

  result = SQL_SUCCESS;

  EXEC SQL
    select max(int(deptno))
    into :highestDeptId
    from department;
    
  if (sqlstate = SQL_SUCCESS);
    asChar = %Char(highestDeptId+1);
    startI = 4 - %len(asChar);
    %subst(result : startI) = asChar;
    Return result;
  endif;

  return EMPTY;
End-Proc;