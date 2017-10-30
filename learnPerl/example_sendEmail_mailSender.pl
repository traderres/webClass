#########################################################################
#  Filename:    sendEmail_mailSender.pl
#########################################################################
#
#  Purpose:
#    To use an SMTP server to send an email to someone
#
#  Design:
#    1) Specify the SMTP server
#    2) Attempt to connect to the SMTP server
#    3) Compose email and send it
#    4) Close SMTP connection
#
# Assumptions:
#    1) SMTP server is accessable from the computer that this script is executed from
#
#  Usage:
#    sendEmail_mailer.pl <enter>
#########################################################################
use strict;
use warnings;

use Time::localtime;
use Mail::Sender;


################################################################
# sendEmail()
#
################################################################
sub sendEmail{
  my ($aFromAddress, $aToAddress, $aSubject, $aBody, $aAttachmentFileList)= @_;

  my $sender;


  if (!($aFromAddress))
   {
     die "sendEmail() failed.  The from address is empty.\n";
   }

  if (!($aToAddress))
   {
     die "sendEmail() failed.  The to address is empty.\n";
   }

  ref ($sender = new Mail::Sender(
      {
          from => $aFromAddress,
         smtp => "2ktirs3"                    # The IP address or hostname of the SMTP server
      }
     )) or die "$Mail::Sender::Error\n";


   if ($aAttachmentFileList)
    {
        print "\tSending an email with attachments....\n";

         # Send email w/attachments             $aAttachmentFileList holds a comma-separated list of files to attach   
          (ref ($sender->MailFile(
           {
            to =>$aToAddress, 
            subject => $aSubject,
            msg => $aBody,
            file => $aAttachmentFileList
          }))
             and print "Mail sent OK."
         )
         or die "$Mail::Sender::Error\n";
     }
    else
     {
        print "\tSending an email with NO attachments....\n";

         # Send email w/o attachments     
          (ref ($sender->MailMsg(
           {
            to =>$aToAddress, 
            subject => $aSubject,
            msg => $aBody
          }))
              and print "Mail sent OK."
         )
         or die "$Mail::Sender::Error\n";
     }
 }




# Declare Variable
my $currentDateTime;
my $g_script_name;
my $from_address;
my $to_address;

# Get the Script name without all of the path information
$currentDateTime = ctime();

$g_script_name = $0;
$g_script_name =~ s/.*\\([^\\]*)$/$1/g;

printf("\n%s has started\n",$g_script_name);


$from_address = "traderres\@yahoo.com";
$to_address = "aresnick\@severn.com";

# S E N D    E M A I L    
sendEmail $from_address, $to_address, "email sent on $currentDateTime", 
            "This is the body of the message";


# S E N D     E M A I L         w/Attachments.
sendEmail $from_address, $to_address, "email sent on $currentDateTime", "This is the body of the message", "bogus.zip, sendEmail_mailer.pl";

printf("\n%s has finished.\n",$g_script_name);

exit 0;
