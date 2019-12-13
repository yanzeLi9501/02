#!/bin/perl

use Makefile::GraphViz;

my $p = Makefile::GraphViz->new;
$p->parse('Makefile');
my $v = $p->plot_all;
$v->as_svg('mk.svg');
