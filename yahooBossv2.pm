#!/usr/bin/perl -w
package yahooBossv2;

use strict;

use yahooBossv2settings;
use LWP::UserAgent;
use URI::Escape;
use Digest::MD5 qw(md5_hex);
use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;

sub new {
    my $class = shift;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(60);
    my $self = {
        "_ua" => $ua
    };
    bless $self, $class;

    return $self
}

sub query {
    my ($self, $query) = @_;
    $query = uri_escape($query);

    my $params = {q => $query, format => 'json'};

    # Source Url  
    my $url = "http://yboss.yahooapis.com/ysearch/".$yahooBossv2settings::boss_buckets;  
  
    # Create request  
    my $request = Net::OAuth->request("request token")->new(  
            consumer_key => $yahooBossv2settings::boss_consumer_key,
            consumer_secret => $yahooBossv2settings::boss_consumer_secret,
            request_url => $url,   
            request_method => 'GET',   
            signature_method => 'HMAC-SHA1',  
            timestamp => time,   
            nonce => md5_hex(rand),
            callback => '',
            extra_params => $params);
  
    # Sign request          
    $request->sign();  
  
    # Get message to the Service Provider  
    my $res = $self->{'_ua'}->get($request->to_url);   
  
    # If request is success, display content  
    if (!$res->is_success) {  
        # Print error and die  
        print "$res\n";
        print $res->content."\n";
print $res->status_line."\n";
        die "Something went wrong";  
    }  

    return $res->content;  
}

1;

# vi:set expandtab sts=4 sw=4:
