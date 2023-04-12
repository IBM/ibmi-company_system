**free

ctl-opt dftactgrp(*no);

/INCLUDE 'qrpgleref/constants.rpgleinc'

dcl-s mytext char(75);

Dcl-PR printf Int(10) extproc('printf');
  input Pointer value options(*string);
End-PR;

mytext = 'This is a bad change';
printf(mytext);

dsply mytext;

return;