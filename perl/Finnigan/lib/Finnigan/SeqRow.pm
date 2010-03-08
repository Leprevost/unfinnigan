package Finnigan::SeqRow;

use strict;
use warnings;

use Finnigan;
use base 'Finnigan::Decoder';

sub decode {
  my ($class, $stream, $version) = @_;

  my @common_fields = (
		       injection          => ['object', 'Finnigan::InjectionData'],
		       "unknown text[a]"  => ['varstr', 'PascalStringWin32'],
		       "unknown text[b]"  => ['varstr', 'PascalStringWin32'],
		       "id"               => ['varstr', 'PascalStringWin32'],
		       "remark"           => ['varstr', 'PascalStringWin32'],
		       "study"            => ['varstr', 'PascalStringWin32'],
		       "client"           => ['varstr', 'PascalStringWin32'],
		       "laboratory"       => ['varstr', 'PascalStringWin32'],
		       "company"          => ['varstr', 'PascalStringWin32'],
		       "phone"            => ['varstr', 'PascalStringWin32'],
		       "inst method"      => ['varstr', 'PascalStringWin32'],
		       "proc method"      => ['varstr', 'PascalStringWin32'],
		       "file name[1]"     => ['varstr', 'PascalStringWin32'],
		       "file Name[2]"     => ['varstr', 'PascalStringWin32'],
		      );

  my %specific_fields;
  $specific_fields{57} = [
			  "unknown text[c]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[d]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[e]"  => ['varstr', 'PascalStringWin32'],
			  "unknown long"     => ['V',      'UInt32'],
			 ];
  
  $specific_fields{62} = [
			  "unknown text[c]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[d]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[e]"  => ['varstr', 'PascalStringWin32'],
			  "unknown long"     => ['V',      'UInt32'],
			  "unknown text[f]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[g]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[h]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[i]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[j]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[k]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[l]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[m]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[n]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[o]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[p]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[q]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[r]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[s]"  => ['varstr', 'PascalStringWin32'],
			  "unknown text[t]"  => ['varstr', 'PascalStringWin32'],

			 ];
  $specific_fields{63} = $specific_fields{62};

  use Data::Dumper;
  print Dumper($specific_fields{63});
  die "don't know how to parse version $version" unless $specific_fields{$version};
  my $self = Finnigan::Decoder->read($stream, [@common_fields, @{$specific_fields{$version}}]);

  return bless $self, $class;
}

sub injection {
  shift->{data}->{injection}->{value};
}

1;

__END__

=head1 NAME

Finnigan::SeqRow -- a decoder for Finnigan injection sequencer data

=head1 SYNOPSIS

  use Finnigan;
  my $seq_row = Finnigan::SeqRow->read(\*INPUT, $version);
  $seq_row->dump(relative => 1); # show relative addresses

=head1 DESCRIPTION

This structure contains an instance of Finnigan::InjectionData and a
bunch of text strings, with one long integer buried among them. Those
strings whose meaning is obvious identify the sample and its
provenance, and some strings are file and directory names.

Finnigan::InjectionData contains injection parameters (vial ID,
volume, weight, etc.)

The file-related strings seem to have the following meaning:

  "inst method":  instrument method file
  "proc method":  processing method file
  "file_name[1]": original raw file name (can be basename or full path)
  "file_name[2]": directory path where raw file was located

=head2 EXPORT

None


=head1 SEE ALSO

Finnigan::IjectionData

=head1 AUTHOR

Gene Selkov, E<lt>selkovjr@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Gene Selkov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut