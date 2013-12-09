
sub send_text {
    my ($text, $server, $win_item) = @_;

    #print "send_text";
    #print "text     :  $text";
    #print "server   :  $server";
    #print "win_item :  $win_item";

    $text =~ tr/oOlLeEaA/00113344/;
    $text =~ s/s /z /gi;
    $text =~ s/73h /t3h /gi;
    $text =~ s/133t/1337/gi;

    #print "newtext  :  $text\n";

    Irssi::signal_continue($text, $server, $win_item);
}

Irssi::signal_add_first("send text", "send_text");
