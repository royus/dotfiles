#!/usr/bin/perl
#Last Change: 2018/11/25 (Sun) 20:07:20.

$latex = 'platex -synctex=1 %O %S';
$bibtex = 'pbibtex %O %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
# $dvipdf = 'dvipdfmx %O %S';
# $makeindex = 'mendex %O -o %D %S';
$max_repeat = 10;
$pdf_mode = 3;
if ($^O eq 'darwin') {
    $pdf_previewer = 'open -a Preview';
} elsif ($^O eq 'linux') {
    $pdf_previewer = 'evince';
}
