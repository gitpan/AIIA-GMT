package AIIA::GMT;

use 5.008008;
use strict;
use warnings;
use Frontier::Client;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use AIIA::GMT ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(_pmid2entites _txt2entities
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(_pmid2entities _txt2entities
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('AIIA::GMT', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.
my $SERVER_URL = 'http://140.109.23.113:8080/XmlRpcServlet';

sub _pmid2entities {
    my $id = shift;
    die "Usage: &_pmid2entities(\'pubmed id\');\n" if ($id != /^\d+$/);
    return &submit($id);
}

sub _txt2entities {
    my $txt = shift;
    $txt =~ s/\n//g;
    my $num;
    map {$num++;} split(/\s/, $txt);
    die "Usage: &_txt2entities(\'< 3000 words\');\n" if ($num > 3000);
    return &submit($txt);
}

sub submit {
    my @args = (shift);
    my $client = Frontier::Client->new(url => $SERVER_URL, debug => 0);
    my $ret = $client->call('Annotator.getAnnotation', @args);
    my @rep;
    map {push @rep, $_->{'offset'} . "\t" . $_->{'mention'};} 
        @{$ret->{'mentions'}};
    @rep = sort @rep;
    return \@rep;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

AIIA::GMT - a XML-RPC client of a web-service server, AIIA gene mention tagger, which provides the service to recognize named entities in the biomedical articles

=head1 SYNOPSIS

 use YAML;
 use AIIA::GMT;

 $result = _txt2entities('< 3000 words');
 print Dump $result;


=head1 DESCRIPTION

AIIA::GMT is a XML-RPC client of a web-service server, AIIA gene mention tagger, which provides the service to recognize named entities in the biomedical articles. 

AIIA gene mention tagger, developed by Adaptive Internet Intelligent Agents Lab, Institute of Information Science, Academia Sinica, Taiwan and I-Fang Chung's Lab, Institute of Bioinformatics, National Yang-Ming University, Taiwan, is a named entity recognition tool which participated in the BioCreative II challenge evaluation and attained a 0.8683 of F-score (ranked 2nd) in the final system assessment of the Gene Mention task.

This module is developed to help those who want to use this remote service with XML-RPC, rather than with its web interface. Finally, this module and service is released under a GPLv3 License. You're free to use it for both academic or personal use.

=head1 METHODS

=over 4

=item _txt2entities( '< 3000 words' );

Return a ARRAY reference which contains all of the entities recognized from your input with its position information, for example: '20 seperated-by-tab human protein-tyrosine-phosphatase'.

=back


=head1 REQUIREMENT

Frontier::Client

=head1 BUGS

Hopefully none.


=head1 SEE ALSO

http://aiia.iis.sinca.edu.tw/biocreative2.htm

=head1 AUTHOR

Cheng-Ju Kuo, E<lt>cju.kuo@gmail.com<gt>>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Cheng-Ju Kuo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
