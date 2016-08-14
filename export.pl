use utf8;
use strict;
use JSON;
use LWP::UserAgent;
use XML::Simple;

binmode STDOUT, ':encoding(cp932)';
binmode STDERR, ':encoding(cp932)';
binmode OUT, ':encoding(Shift-JIS)';

my $login_info = {
    mail_tel => 'your@mail.com',
    password => 'password'
};

my $ua =  LWP::UserAgent->new(cookie_jar => {});

$ua->post("https://secure.nicovideo.jp/secure/login?site=niconico", $login_info);
print STDERR "Logged in. \n";
print STDERR "mail:".$login_info->{mail_tel}."\n";
print STDERR "pass:".$login_info->{password}."\n";

$ua->get("http://www.nicovideo.jp/my/mylist")->content =~ /NicoAPI.token = "([^"]+)/s;
my $token = $1;
print STDERR "Loaded token. \n";
print STDERR "token:".$token."\n";

my $json = $ua->get("http://www.nicovideo.jp/api/mylistgroup/list")->content;
my $mylistgroup = decode_json($json)->{mylistgroup};
print STDERR "Loaded MylistGroup. \n";

my $path = "xml";
if( -d $path ){
   # do nothing.
} else {
   mkdir($path);
   print STDERR "Created directory.";
}

print STDERR "Exporting...";

foreach my $group (reverse(@$mylistgroup)) {
    my $id = $group->{id};
    my $name = $group->{name};
    
    my $url = "http://www.nicovideo.jp/mylist/${id}?rss=2.0";
    my $mylist = $ua->get($url)->content;
    
    open(OUT, '> xml/'.Encode::encode('CP932', $name).'.xml');
    print OUT $mylist;
    print STDERR $name.".xml\n";
    close(OUT);
}

print STDERR "Done.";
