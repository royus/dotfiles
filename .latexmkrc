#!/usr/bin/perl
#Last Change: 2017/04/12 (Wed) 11:31:08.

$latex = 'platex -synctex=1 %O %S';
$bibtex = 'pbibtex %O %B';
$dvipdf = 'dvipdfmx %O %S';
$pdf_mode = 3;
$pdf_previewer = 'start evince';
