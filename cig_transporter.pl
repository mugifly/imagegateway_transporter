#! /usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.10.0;

use lib 'lib/';
use CIG::MailParser;
use CIG::ImageFetcher;

my $parser = CIG::MailParser->new();
my $fetcher = CIG::ImageFetcher->new();

# Parse a mail
my $page_url = $parser->parse($mail);

if (defined($page_url)) {
	say $page_url;
	# Fetch a image
	$fetcher->fetch_save($page_url, 'image/');
}


exit;