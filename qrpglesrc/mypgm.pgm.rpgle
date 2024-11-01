**free

ctl-opt dftactgrp(*no);

/INCLUDE 'qrpgleref/constants.rpgleinc'

dcl-s mytext char(50);

Dcl-PR printf Int(10) extproc('printf');
  input Pointer value options(*string);
End-PR;

mytext = 'Hello, I am testing a broken change for a demo!'';
printf(mytext);

dsply mytext;

return;