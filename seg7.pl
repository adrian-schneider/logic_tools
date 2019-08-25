#!/usr/bin/perl
use strict;
use warnings;

use File::Spec::Functions qw/canonpath/;

my $in_file_name = $ARGV[-1];
my $f_debug = 1;

my @seg_list = ();

sub non_empty {
  my $cc = shift;
  return (($cc ne ' ') && ($cc ne '')) ? 1 : 0;
}


sub v_bar {
  my $cc = shift;
  return non_empty($cc) ? '|' : ' ';
}


sub h_bar {
  my $cc = shift;
  return non_empty($cc) ? '_' : ' ';
}


sub printfile {
  my $fname = shift;
  open (my $fh, "<", $fname);
  while (<$fh>) {
    chomp;
    print "$_\n";
  }
  close $fh;
}

sub read_seg_file {
  open(my $in_file, '<', $in_file_name) or die "Cannot open $in_file_name, $!";

  my $pos0 = -1;
  my $state = -1;
  my $code = -1;
  my $segbin = 0;
  my ($seg_a, $seg_b, $seg_c, $seg_d, $seg_e, $seg_f, $seg_g) = ('', '', '', '', '', '', '');

  while (my $line = <$in_file>) {
    chomp $line;

    next if ($line =~ /^\s*#/);

    if ($line =~ /.(.).\.(.+)/) {
      $state = 0;
      $pos0 = $-[0]; # start position of the match.
      ($seg_a, $seg_b, $seg_c, $seg_d, $seg_e, $seg_f, $seg_g) = (h_bar($1), '', '', '', '', '', '');
      $code = $2;
      $segbin = non_empty($1);
      next;
    }

    if (($state == 0) && ($line =~ /\s{$pos0}(.?)(.?)(.?)/)) {
      $state = 1;
      ($seg_f, $seg_g, $seg_b) = (v_bar($1), h_bar($2), v_bar($3));
      $segbin += (non_empty($1) << 5) + (non_empty($2) << 6) + (non_empty($3) << 1);
      next; 
    }

    if (($state == 1) && ($line =~ /\s{$pos0}(.?)(.?)(.?)/)) {
      $state = -1;
      ($seg_e, $seg_d, $seg_c) = (v_bar($1), h_bar($2), v_bar($3));
      $segbin += (non_empty($1) << 4) + (non_empty($2) << 3) + (non_empty($3) << 2);
  
      $seg_list[$code] = $segbin;

      if ($f_debug) {
        print("   $seg_a  $code\n");
        print("  $seg_f$seg_g$seg_b\n");  
        print("  $seg_e$seg_d$seg_c\n");
        printf("  %08b\n", $segbin);  
      }
    }
  }
}


sub write_minterm_files {
  my $segbit = 1;
  my $seg = 0;
  my $out_file_name = "./seg7xxxx.tmp";
  while ($segbit < (1 << 7)) {
    open(my $out_file, '>', $out_file_name) or die "\n";

    my $segchr = chr(ord('a') + $seg);
    #print $out_file "# START seg $segchr\n";

    # Number of variables
    print $out_file "4\n";
    # Number of minterms
    my $nummin = 0;
    for (my $ii = 0; $ii < scalar @seg_list; $ii++) {
      $nummin++ if ($seg_list[$ii] & $segbit);
    }
    print $out_file "$nummin\n";
    # Number of don't cares
    print $out_file "0\n";
    # Minterms
    for (my $ii = 0; $ii < scalar @seg_list; $ii++) {
      if ($seg_list[$ii] & $segbit) {
        print $out_file "$ii\n";
      }
    }
    #print $out_file "# END seg $segchr\n";
    $segbit <<= 1;
    $seg++;

    close($out_file);

    print "-- segment $segchr\n";
	#printfile($out_file_name);
	my $cmd = canonpath("./qm") . " " . canonpath("$out_file_name");
    system($cmd);
  }
  unlink($out_file_name);
}


read_seg_file;
write_minterm_files;

