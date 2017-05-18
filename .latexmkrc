#!/usr/bin/perl
#Last Change: 2017/05/18 (Thu) 14:14:22.

$latex = 'platex -synctex=1 %O %S';
$bibtex = 'pbibtex %O %B';
$dvipdf = 'dvipdfmx %O %S';
$pdf_mode = 3;
$pdf_previewer = 'evince';
