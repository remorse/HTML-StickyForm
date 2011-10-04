# $Id: 20hidden.t,v 1.2 2011/10/04 19:58:19 pmh Exp $

use Test::More no_plan;
use Test::XML;
use strict;

use CGI;
my $Form;
BEGIN{ use_ok($Form='HTML::StickyForm'); }

isa_ok(my $empty=$Form->new,$Form,'empty object');
isa_ok(my $full=$Form->new(CGI->new({fred => 'bloggs'})),$Form,'full object');

for(
  [{},'empty',
    '<input type="hidden" name="" value="" />',
    '<input type="hidden" name="" value="" />',
  ],
  [{name => 'fred'},'fred',
    '<input type="hidden" name="fred" value="" />',
    '<input type="hidden" name="fred" value="bloggs" />',
  ],
  [{name => 'fred',default => 'jones'},'fred/default',
    '<input type="hidden" name="fred" value="jones" />',
    '<input type="hidden" name="fred" value="bloggs" />',
  ],
  [{name => 'fred',value => 'jones'},'fred/value',
    '<input type="hidden" name="fred" value="jones" />',
    '<input type="hidden" name="fred" value="jones" />',
  ],
){
  my($args,$name,$expect_empty,$expect_full)=@$_;

  my $out;
  is_xml($out=$empty->hidden($args),$expect_empty,"$name (empty, ref)")
    or diag $out;
  is_xml($out=$empty->hidden(%$args),$expect_empty,"$name (empty, flat)")
    or diag $out;
  is_xml($out=$full->hidden($args),$expect_full,"$name (full, ref)")
    or diag $out;
  is_xml($out=$full->hidden(%$args),$expect_full,"$name (full, flat)")
    or diag $out;
}


