#!perl
use strict;
use warnings;

use Config::Neat;
use Net::Amazon::S3;

my $s3 = Net::Amazon::S3->new(
    {   aws_access_key_id     => $ENV{'AWS_ACCESS_KEY'},
        aws_secret_access_key => $ENV{'AWS_SECRET_KEY'},
        host                  => 's3-eu-west-1.amazonaws.com',
    }
);
my $bucket = $s3->bucket('andrew-jones.com');

my $cfg = Config::Neat->new();
my $data = $cfg->parse_file('arjones-nginx.conf');

for my $locationBlock (@{$data->{'server'}->{'location'}}){
	my $location = $locationBlock->{''};
	my $return = $locationBlock->{'return'};

	next unless $location->[0] eq '=';

	next if $location->[1] eq '/';

	populateRedirect($location->[1], $return->[1]);
}

sub populateRedirect {
	my($source, $destination) = @_;

	$source =~ s/"//g;
	$source =~ s!^/!!;
	$source =~ s!/$!!;

	return unless $source;

	$destination =~ s/;$//;
	$destination =~ s!http://blog.andrew-jones.com/!/blog/!;

	$bucket->add_key(
    "$source/index.html",
    "redirect from $source to $destination",
    {
      'x-amz-website-redirect-location' => "$destination",
      'Content-Type' => 'text/plain',
    })
    or die $s3->err . ": " . $s3->errstr;
}