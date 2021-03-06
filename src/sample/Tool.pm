#!/usr/bin/perl
package Tool;
BEGIN{
    my $LIB="/usr/local/geta/ext/wam/"; # should change!
    unshift(@INC,"$LIB","$LIB/blib/lib","$LIB/blib/arch");
};
use Getopt::Std;
use wam('WAM_ROW','WAM_COL');
use Encode qw/encode decode/;

$w1;

sub init{
    my $handle = shift;
    my $ci_conf = "ci.conf";
    $GETAROOT="/usr/local/geta/";     # should change!
    &wam::init($GETAROOT,$ci_conf) == 0 or die "ERROR: cannot initialize";
    ($w1 = &wam::open($handle) != 0) or die  "$handle: cannot open";
}

sub close{
    my $handle = shift;
    &wam::close($w1);
}

sub getdoc{
    my ($w,$orflag) = @_;
    my $rq = (); my $rd = (); my $rw = ();
    my $j = 0;
    my @ww = split(/[\s]+/,$w);
    for(my $i=0;$i<@ww;$i++){
	my $id = &wam::name2id($w1,WAM_COL,$ww[$i]);
	next unless $id;
	$rq->[$j]{name} = $ww[$i];
	$rq->[$j]{id} = $id;
	$rq->[$j]{TF} = 1;
	$rq->[$j]{TF_d} = 1;
	$rq->[$j]{weight} = 1;
	$rq->[$j]{attr} = $orflag ? &wam::WSH_OR: &wam::WSH_AND;
	$j++;
    }
    if ($j>0){
        $rd = &wam::wsh($rq,$w1,WAM_COL,&wam::WT_SMART,10000000,0,$w1); # ʸ��ꥹ��
    }
    return $rd;
}

sub getword {
    my $doc = shift;
    my $rw = &wam::wsh($doc,$w1,WAM_ROW,&wam::WT_SMART,10000000,0,$w1); # ñ��ꥹ��
    return $rw;
}

sub getwords {
    my $docname = shift;
    my $rw;
    my $doc;
    my $id = &wam::name2id($w1,WAM_ROW,$docname);
    return $rw unless $id;
    $doc->[0]{name} = $docname;
    $doc->[0]{id} = $id;
    $doc->[0]{TF} = 1;
    $doc->[0]{TF_d} = 1;
    $doc->[0]{weight} = 1;
    $doc->[0]{attr} = &wam::WSH_OR;
    my $rw = &wam::wsh($doc,$w1,WAM_ROW,&wam::WT_SMART,10000000,0,$w1); # ñ��ꥹ��
    return $rw;
}

sub getdocword{
    my ($w,$orflag) = @_;
    my $rq = (); my $rd = (); my $rw = ();
    my $j = 0;
    my @ww = split(/[\s]+/,$w);
    for(my $i=0;$i<@ww;$i++){
        my $w_encode = encode('ISO-2022-JP', decode('utf8', $ww[$i]));
        my $id = &wam::name2id($w1,WAM_COL,$w_encode);
        last unless $id;
        $rq->[$j]{name} = $ww[$i];
        $rq->[$j]{id} = $id;
        $rq->[$j]{TF} = 1;
        $rq->[$j]{TF_d} = 1;
        $rq->[$j]{weight} = 1;
        $rq->[$j]{attr} = $orflag ? &wam::WSH_OR :&wam::WSH_AND;
        $j++;
    }
    if ($j>0){
        $rd = &wam::wsh($rq,$w1,WAM_COL,&wam::WT_SMART,10000000,0,$w1); # ʸ��ꥹ��
	    $rw = &wam::wsh($rd,$w1,WAM_ROW,&wam::WT_SMART,10000000,0,$w1); # ñ��ꥹ��
    }
    return ($rd,$rw);
}

sub id2name {
    my $id = shift;
    return &wam::id2name($w1,WAM_COL,$id);
}

sub name2id {
    my $name = shift;
    return &wam::name2id($w1,WAM_COL,$name);
}

1;
