# $Id: Google.pm,v 1.2 2004/08/03 10:28:15 giuseppe Exp $
#========================================================================
# google:     HTTP GET of a Google query. First n links are displayed.
#
#             Example:
#               ./google.pl -n 5 camaro
#
#             n defaults to 10.
#             Query string defaults to "camaro".
#             No need to quote or encode the query string.
#
#             Valid & equivelant:
#               ./google.pl "apple computer"
#               ./google.pl apple+computer
#               ./google.pl apple computer
#
# Version:    3/1/2001.  Joe Trofimczuk, xchat@joe2net.com
#             Initial version.
#
#========================================================================
# Note: Previous comments are useful only if you use thi pm as standalone app
# 	after some modifications.
#========================================================================
package Google;
use Exporter;
@ISA=qw(Exporter);
@EXPORT_OK=qw(google);

use strict;

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;

sub google {
    my $N = 5;
    my $query = "$_[0]";
    my @result;
    my $el;
    my $URL = "www.google.com/search?num=100&q=";
    my $ua = LWP::UserAgent->new();
    $ua->agent("Mozilla/4.7 [en] (X11; U; Linux 2.2.17 i686)");
    my $req = HTTP::Request->new(GET => "http://".$URL.$query);
    $req->header(Accept  => "text/html");
    my $contentResponse = $ua->request($req);
    my $count = 0;
    my $stuff = $contentResponse->content;
    #print $stuff;
    #while ($stuff  =~ m/.*<font color="#008000">(.*\/)\s-\s\d+k/g)
    $el=-1;
    while ($stuff  =~ m/.*<p><a href=http:\/\/(.*?)>.*?<\/a><br><font size=-1>/gi) {
	if (++$count > $N) { last; }
	$result[++$el]="$1\n";
    }
    return @result;
}

1;
