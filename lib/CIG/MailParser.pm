package CIG::MailParser;

use strict;
use warnings;
use utf8;

sub new {
	my ($class) = @_;
	my $self = bless({}, $class);
	return $self;
}

sub parse {
	my ($self, $mail_text) = @_;
	if($mail_text =~ /.*閲覧はこちら\n(http:\/\/\S+)/m){
		my $page_url = $1;
		return $page_url;
	}
	return undef;
}

1;

