use utf8;
use strict;
use JSON;
use LWP::UserAgent;
use XML::Simple;

binmode STDOUT, ':encoding(cp932)';
binmode STDERR, ':encoding(cp932)';
binmode OUT, ':encoding(Shift-JIS)';

my $login_info = {
    mail => 'your@mail.com',
    password => 'password'
};


# Get user agent
my $ua =  LWP::UserAgent->new(cookie_jar => {});

# Get Ticket
my $response = $ua->post("https://secure.nicovideo.jp/secure/login?site=nicoalert", $login_info);
my $ticket = XMLin($response->content)->{ticket};
print STDERR "Got ticket. \n";
print STDERR "ticket: ".$ticket." \n";

my $parm = {
    ticket => $ticket
};

# Get Userhash / Username
   $response = $ua->post("http://alert.nicovideo.jp/front/getalertstatus", $parm);
my $hash = XMLin($response->content)->{user_hash};
my $id = XMLin($response->content)->{user_id};
print STDERR "Got Username/Userhash. \n";
print STDERR "hash: ".$hash." \n";
print STDERR "id: ".$id." \n";

$parm = {
    user_hash => $hash,
    user_id => $id
};

# Get Communities
   $response = $ua->post("http://alert.nicovideo.jp/front/getcommunitylist", $parm);
print STDERR $response->content;
