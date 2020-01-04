#!/usr/bin/perl
BEGIN{
    push @INC,'./';
}
use Getopt::Std;
use Tool;
use Encode qw/encode decode/;

getopts("hd:q:n:m:");
if ($opt_h){
    print <<EOF;
usage: perl search.pl [-h] [-d db] [-q query] [-n n]
  -h : show this message
  -d : database
  -q : query
  -n : number of results, default n=10
EOF
    exit 0
}
my $db = $opt_d ? $opt_d : "sample";
my $q  = $opt_q ? $opt_q : "z";
my $n  = $opt_n ? $opt_n : 5;
my $m  = $opt_m ? $opt_m : 5;
&Tool::init($db);
my ($doc,$word) = &Tool::getdocword($q);
my @ws = sort {$b->{DF_d}<=>$a->{DF_d}} grep{($_->{name} !~ /:/)&&($_->{name} ne "z")} @$word;
printf "%d %s\n",scalar @$doc,$q;
for(my $i=0;($i<@ws)&&($i<$n);$i++){
    $name = encode('utf8',decode('ISO-2022-JP', $ws[$i]->{name}));
    printf "%2d %3d %7.4f %s\n",$i+1,$ws[$i]->{DF_d},$ws[$i]->{weight},$name;
}
