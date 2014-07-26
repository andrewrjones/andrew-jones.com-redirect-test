use Modern::Perl '2014';

use Test::More;
use Search::Sitemap;
use LWP::UserAgent;

use Data::Dumper;

my $ua = LWP::UserAgent->new;

subtest 'project URLs' => sub {
	#plan skip_all => 'for now';
	my $base = 'http://andrew-jones.com';
	my @urls;
	for(qw{
		jquery-placeholder-plugin
		jquery-placeholder-plugin
	}){
		push @urls, "$base/$_";
	}
	test_urls(@urls);
};

subtest 'Test from pre 2014-07 sitemap' => sub {
	#plan skip_all => 'for now';
	my $map = Search::Sitemap->new();
	$map->read( 'sitemap-2014-07.xml' );
	my @urls = $map->urls->all;

	for my $url(@urls){
		test_url($url->loc->as_string);
	}
};

subtest 'blog.andrew-jones.com' => sub {
	#plan skip_all => 'for now';
	my $base = 'http://blog.andrew-jones.com';
	my @urls;
	for(qw{
		/
		feed
		tag/perl
		category/perl
		2010/10/08/getting-the-date-from-the-iso-week-number-in-perl/
		2010/09/12/carmelite-church-and-the-chapel-of-bones-faro-portugal/
		2010/08/25/jquery-placeholder-plugin-released/
		2009/12/01/using-a-quarter-interval-with-the-simile-timeline/
		2009/09/24/kino-search-add-on-released-for-foswiki/
		2009/08/15/improving-the-web-index-in-foswiki-using-the-filter-plugin/
		2009/06/23/the-linux-at-command/
		2009/06/03/connecting-to-cisco-vpn-with-ubuntu-9dot04/
		2009/04/20/copying-objects-in-javascript/
		2009/02/03/removing-referral-url-using-a-perl-proxy-script/
		2009/01/09/foswiki-1dot0-released/
		2008/11/02/twiki-and-the-fork/
		2010/10/12/running-royal-parks-half-marathon/
		2010/10/28/nasa-publishes-evidence-on-climate-change-will-it-convince-the-sceptics/
		2010/12/06/perl-compiled-regexs-and-fastcgi/
		2010/12/10/fame/
		2011/01/18/html5-the-new-web-2-0/
		2011/01/28/new-version-of-the-jquery-placeholder-plugin-released/
		2011/02/17/jquery-email-address-munging-plugin-released/
		2011/02/24/arsenal-1-0-stoke/
		2011/04/08/introducing-a-ruby-library-for-the-duck-duck-go-api/
		2011/04/13/ruby-duck-duck-go-library-updated-to-1-1-0/
		2011/05/08/ecuadors-oil-gamble/
		2011/06/02/catching-up-with-the-competition/
		2011/06/08/google-announces-support-for-relauthor/
		2011/06/22/how-not-to-respond-to-your-oss-bug-reports/
		2011/07/08/emulator-not-working-on-windows-with-android-sdk-r12/
		2011/07/15/titanium-and-android-first-impressions/
		2011/07/22/doing-the-london-to-cambridge-bike-ride-sponsorship-plea/
		2011/07/25/my-photo-to-be-used-in-the-schmap-london-guide/
		2011/07/27/chrome-bookmarks-folder-removed-from-google-docs/
		2011/07/29/completed-the-london-to-cambridge-bike-ride-2011/
		2011/07/30/natural-scrolling/
		2011/10/10/mp4meta-apply-itunes-like-metadata-to-an-mp4-file/
		2011/11/27/gcal-a-command-line-interface-to-google-calendar/
	}){
		push @urls, "$base/$_";
	}
	test_urls(@urls);
};

subtest 'arjones.co.uk' => sub {
	#plan skip_all => 'for now';
	my $base = 'http://arjones.co.uk';
	my @urls;
	for(qw{
		/
		/2
		/3
	}){
		# TODO: test other short URLs?
		push @urls, "$base/$_";
	}
	test_urls(@urls);
};

subtest 'ci.arjones.co.uk' => sub {
	#plan skip_all => 'for now';
	my $base = 'http://ci.arjones.co.uk';
	my @urls;
	for(qw{
		/
		/builders/gcal
	}){
		push @urls, "$base/$_";
	}
	test_urls(@urls);
};

sub test_urls {
	for(@_){
		test_url($_);
	}
}

sub test_url {
	my $url = shift;
	my $request  = HTTP::Request->new( HEAD => $url );
	my $response = $ua->request($request);

	ok($response->is_success, $url);
}


done_testing();