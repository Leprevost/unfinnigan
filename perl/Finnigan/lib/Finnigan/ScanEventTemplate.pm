package Finnigan::ScanEventTemplate;

use strict;
use warnings;

use Finnigan;
use base 'Finnigan::Decoder';

use overload ('""' => 'stringify');

sub decode {
  my ($class, $stream, $version) = @_;

  my @fields = (
		     "preamble"           => ['object',  'Finnigan::ScanEventPreamble'],
		     "unknown long[1]"    => ['V',       'UInt32'],
		     "unknown long[2]"    => ['V',       'UInt32'],
                     "fraction collector" => ['object', 'Finnigan::FractionCollector'],
		     "unknown long[3]"    => ['V',       'UInt32'],
		     "unknown long[4]"    => ['V',       'UInt32'],
		     "unknown long[5]"    => ['V',       'UInt32'],
		    );

  my $self = Finnigan::Decoder->read($stream, \@fields, $version);
  bless $self, $class;
  return $self;
}

sub preamble {
  shift->{data}->{"preamble"}->{value};
}

sub fraction_collector {
  shift->{data}->{"fraction collector"}->{value};
}

sub stringify {
  my $self = shift;

  my $p = $self->preamble;
  my $f = $self->fraction_collector;
  return "$p $f";
}


1;
__END__

=head1 NAME

Finnigan::ScanEventTemplate -- a decoder for ScanEventTemplate, a scan descriptor prototype

=head1 SYNOPSIS

  use Finnigan;
  my $e = Finnigan::ScanEventTemplate->decode(\*INPUT);
  say $e->size;
  say $e->dump;
  say join(" ", $e->preamble->list(decode => 'yes'));
  say $e->preamble->analyzer(decode => 'yes');
  $e->fraction_collector->dump;
  $e->reaction->dump if $e->type == 1 # Reaction will not be present in MS1

=head1 DESCRIPTION

This is a template structure that apparently forms the core of every
scan's ScanEvent structure. It is an elment of MSScanEvent hirerachy
that models the hierarchy of scan segments and scan events.

=head2 EXPORT

None

=head1 SEE ALSO

Finnigan::ScanEvent
Finnigan::ScanEventPreamble
Finnigan::FractionCollector
Finnigan::Reaction

=head1 AUTHOR

Gene Selkov, E<lt>selkovjr@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Gene Selkov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut