#! /usr/bin/env perl
# iMAGE GATEWAY Transporter - 1.0.0
# https://github.com/mugifly/imagegateway_transporter

use strict;
use warnings;
use utf8;
use 5.10.0;

use lib 'lib/';
use ImageGatewayNet::MailParser;
use ImageGatewayNet::ImageFetcher;

my $parser = ImageGatewayNet::MailParser->new();
my $fetcher = ImageGatewayNet::ImageFetcher->new();

# Parse a mail
my $mail_text = <<'EOF';

EOF

my $page_url = $parser->parse($mail_text);
if (defined($page_url)) {
	say $page_url;
	# Fetch a image
	$fetcher->fetch_save($page_url, 'image/');
}

exit;