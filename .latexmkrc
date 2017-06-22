#!/usr/bin/perl
#Last Change: 2017/06/22 (Thu) 07:02:53.

$latex = 'platex -synctex=1 %O %S';
$bibtex = 'pbibtex %O %B';
$dvipdf = 'dvipdfmx %O %S';
$pdf_mode = 3;
$pdf_previewer = 'evince';
