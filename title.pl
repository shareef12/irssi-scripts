
use strict;
use vars qw($VERSION %IRSSI @servList);

use Regexp::Common qw/URI/;
use LWP::Simple;
use HTML::Entities;

$VERSION = '0.1';
%IRSSI = (
    authors => 'Christian Sharpsten',
    contact => 'shar33f12@gmail.com',
    name => 'titleBot',
    description => 'Irssi script that post titles for links posted',
);
@servList = (
    'beitshlomo',
);

sub handle {
    my ($server, $msg, $nick, $target) = @_;
  
    $msg =~ s/https:\/\//http:\/\//gi;  # strip https
    return unless $msg =~ /$RE{URI}{HTTP}{-keep}/ && $server->{tag} ~~ @servList;
    #return unless $msg =~ /.*(https?:\/\/[^\s]).*/i;
    my $url = $1;
    print "$nick-->$target : $1";

    my $page = get("$url");
    if ($page =~ /<title>(.*)<\/title>/i) {
        my $title = decode_entities($1);
        print "^ $title";
        $server->command("msg $target ^ $title");
    }

}



sub message_public {
    my ($server, $msg, $nick, $address, $target) = @_;
    Irssi::signal_continue($server, $msg, $nick, $address, $target);
    handle($server, $msg, $nick, $target);
}

sub message_private {
    my ($server, $msg, $nick, $address) = @_;
    Irssi::signal_continue($server, $msg, $nick, $address);
    handle($server, $msg, $nick, $nick);
}

sub message_own_public {
    my ($server, $msg, $target) = @_;
    Irssi::signal_continue($server, $msg, $target);
    handle($server, $msg, $server->{nick}, $target);
}

sub message_own_private {
    my ($server, $msg, $target, $orig_target) = @_;
    Irssi::signal_continue($server, $msg, $target, $orig_target);
    handle($server, $msg, $server->{nick}, $target);
}


Irssi::signal_add("message public", "message_public");
Irssi::signal_add("message private", "message_private");
Irssi::signal_add("message own_public", "message_own_public");
Irssi::signal_add("message own_private", "message_own_private");
