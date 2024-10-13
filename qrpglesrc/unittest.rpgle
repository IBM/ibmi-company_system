**free

ctl-opt nomain
        option(*nodebugio:*srcstmt:*nounref)
        alwnull(*usrctl);

/copy RPGUNIT1,TESTCASE

dcl-proc test_SIMPLE_EXAMPLE export;
  dcl-pi *n;
  end-pi;
  
  assert(*on : 'Test was not successful.');
end-proc;

dcl-proc test_SIMPLE_FAIL_EXAMPLE export;
  dcl-pi *n;
  end-pi;
  
  assert(*off : 'This message should be seen.');
end-proc;
