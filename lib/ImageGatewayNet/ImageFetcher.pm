package ImageGatewayNet::ImageFetcher;

use strict;
use warnings;
use utf8;

use LWP::UserAgent;
use HTML::TreeBuilder;

sub new {
	my ($class) = @_;
	my $self = bless({}, $class);

	$self->{ua_string} = 'Mozilla/5.0 (ja-JP) ImageGatewayTransporter/1.0.0';
	
	$self->{ua} = LWP::UserAgent->new('agent' => $self->{ua_string});

	return $self;
}

# Fetch and save images, from page url.
sub fetch_save {
	my ($self, $page_url, $save_path) = @_;
	$save_path = $save_path || "./";

	my @image_urls = $self->page_fetch($page_url);

	my @image_paths = ();

	unless(-d $save_path){
		mkdir $save_path;
	}

	foreach my $image_url(@image_urls){
		# Fetch image binary
		my $res = $self->{ua}->get($image_url);
		if ($res->is_success) {
			# Save to file
			my $filename;
			if($image_url =~ /([^\/]+\.(jpg|png))?(\?.*|)$/i){
				$filename = $1;
			}
			open my $fh, '>', $save_path.$filename;
			binmode $fh;
			print $fh $res->content;
			close $fh;
		}
	}
	return @image_paths;
}

# List image urls by fetching page.
sub page_fetch {
	my ($self, $page_url) = @_;

	my $res = $self->{ua}->get($page_url);
	my $content = $res->content;

	# Parse html
	my $tree = HTML::TreeBuilder->new();
	$tree->parse($content);

	# Image url
	my @link = $tree->look_down('id', 'jsOriginalImageLink');
	unless(defined($link[0])){
		return ();
	}
	my $image_url = $link[0]->attr('href');
	unless(defined($image_url)){
		return ();
	}

	my @ret = ($image_url);

	# Next Image page
	my $next_page_url = undef;
	foreach my $tag($tree->find('li')){
		if(defined($tag->look_down('id', 'jsNextUrl'))){
			$next_page_url = $tag->look_down('id', 'jsNul__')->attr('value');
			last;
		}
	}
	if($next_page_url){
		my $domain = "";
		if($page_url =~ /(http:\/\/[^\/]*)/){
			$domain = $1;
		}
		# Fetch a next image
		push(@ret, $self->page_fetch($domain . $next_page_url) );
	}

	return @ret;
}

1;