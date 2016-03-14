use Modern::Perl '2014';

use Search::Sitemap;
use Net::Amazon::S3;

my $s3 = Net::Amazon::S3->new(
    {   aws_access_key_id     => $ENV{'AWS_ACCESS_KEY'},
        aws_secret_access_key => $ENV{'AWS_SECRET_KEY'},
        host                  => 's3-eu-west-1.amazonaws.com',
    }
);
my $bucket = $s3->bucket('andrew-jones.com');

my $map = Search::Sitemap->new();
$map->read( 'sitemap-2014-07.xml' );
my @urls = $map->urls->all;

for my $url(@urls){
  my $source = $url->loc->as_string;
  $source =~ s!^http://andrew-jones.com/!!;
  $source =~ s!/$!!;
  my $destination = $source;
  $destination =~ s!\d\d\d\d/\d\d/\d\d/!!;

  $bucket->add_key(
    "$source/index.html",
    "redirect from $source to $destination",
    {
      'x-amz-website-redirect-location' => "/$destination",
      'Content-Type' => 'text/plain',
    })
    or die $s3->err . ": " . $s3->errstr;
}