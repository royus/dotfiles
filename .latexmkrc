#!/usr/bin/perl
#Last Change: 2018/03/16 (Fri) 17:43:24.

$latex = 'platex -synctex=1 %O %S';
$bibtex = 'pbibtex %O %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
# $dvipdf = 'dvipdfmx %O %S';
# $makeindex = 'mendex %O -o %D %S';
$max_repeat = 10;
$pdf_mode = 3;
$pdf_previewer = 'evince';
