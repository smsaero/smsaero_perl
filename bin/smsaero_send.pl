#!/usr/bin/env perl

use strict;
use warnings;
use lib 'lib';
use Getopt::Long;
use Pod::Usage;
use SmsAero;
use Data::Dumper;
use Log::Log4perl qw(:easy);

$| = 1;

sub send_sms {
    my ($email, $api_key, $phone, $message) = @_;

    my $sms = SmsAero->new(
        email => $email,
        api_key => $api_key,
        signature => 'Sms Aero'
    );

    return $sms->send_sms(
        number => $phone,
        text => $message
    );
}

sub main {
    my ($email, $api_key, $phone, $message, $help);

    GetOptions(
        'email=s' => \$email,
        'api_key=s' => \$api_key,
        'phone=s' => \$phone,
        'message=s' => \$message,
        'help|h' => \$help
    ) or pod2usage(2);

    pod2usage(1) if $help;
    pod2usage(2) unless ($email && $api_key && $phone && $message);

    eval {

        Log::Log4perl->easy_init($DEBUG);

        my $result = send_sms($email, $api_key, $phone, $message);
        print "Message sent successfully:\n";
        print Dumper($result);
    };
    if ($@) {
        print STDERR "An error occurred: $@\n";
        exit 1;
    }
}

main();

__END__

=head1 NAME

smsaero-cli.pl - Send SMS messages via SmsAero API

=head1 SYNOPSIS

smsaero-cli.pl [options]

 Options:
   --email     Email registered with SmsAero
   --api_key   SmsAero API key
   --phone     Recipient phone number
   --message   Message text
   --help      Show this help message

=head1 DESCRIPTION

This script provides a command line interface for sending SMS messages via SmsAero.

=head1 EXAMPLES

    ./smsaero-cli.pl --email=user@example.com --api_key=YOUR_API_KEY --phone=79001234567 --message="Test message"

=cut
