#!/usr/bin/perl

use warnings;
use strict;

use Cwd;

# change here where your dirs are saved
my $filename = "$ENV{HOME}/.dirs";

if(@ARGV == 1){
  if($ARGV[0] eq 'a'){
		my @dirs = readdirs();
		my $dir = getcwd();
		chomp($dir);
		print "adding $dir\n";
		push(@dirs, $dir);
		writedirs(@dirs);
	}
	elsif($ARGV[0] eq 'c'){
		print "clearing dirs\n";
		my @dirs = ();
		writedirs(@dirs);
	}
	elsif($ARGV[0] =~ /\d+/){
		my @dirs = readdirs();
		if($ARGV[0] > -1 && $ARGV[0] < @dirs){
			print $dirs[$ARGV[0]] . "\n";
		}
		else{
			printusage();
		}
	}
	else{
		printusage();
	}
}
elsif(@ARGV == 2){
	if($ARGV[0] eq 's'){
		if($ARGV[1] =~ /\d+/){
			my @dirs = readdirs();
			my $dir = getcwd();
			chomp($dir);
			$dirs[$ARGV[1]] = $dir;
			writedirs(@dirs);
		}
		else{
			printusage();
		}
	}
	elsif($ARGV[0] eq 'd'){
		if($ARGV[1] =~ /\d+/){
			my @dirs = readdirs();
			if($ARGV[1] < @dirs){
				print "deleting $ARGV[1]: $dirs[$ARGV[1]]\n";
			}
			else{
				print "no such directory saved\n";
				exit 0;
			}
			my $num = @dirs;
			my @newdirs;
			for(my $i = 0; $i < $num; $i++){
				if($i != $ARGV[1]){
					push(@newdirs, shift(@dirs));
				}
				else{
					shift(@dirs);
				}
			}
			writedirs(@newdirs);
		}
		else{
			printusage();
		}
	}
	elsif($ARGV[0] eq 'a'){
		my @dirs = readdirs();
		push(@dirs, $ARGV[1]);
		writedirs(@dirs);
	}
	else{
		printusage();
	}
}
elsif(@ARGV == 3){
	if($ARGV[1] eq 's'){
		if($ARGV[2] =~ /\d+/){
			my @dirs = readdirs();
			$dirs[$ARGV[2]] = $ARGV[3];
			writedirs(@dirs);
		}
		else{
			printusage();
		}
	}
	else{
		printusage();
	}

}
else{
	# print dirs
	my @dirs = readdirs();
	my $i = 0;
	for my $dir (@dirs){
		print $i++ . ": " . $dir . "\n";
	}
}

sub readdirs {
	#my $filename = "$ENV{HOME}/.dirs";
	open(my $fh, "<", $filename) or die "could not open $filename for reading\n$!\n";
	my @dirs;
	while(my $line = <$fh>){
		chomp($line);
		push(@dirs, $line);
	}
	close($fh);
	return @dirs;
}

sub writedirs {
	#my $filename = "$ENV{HOME}/.dirs";
	open(my $fh, ">", $filename) or die "could not open $filename for writing\n$!\n";
	while(my $line = shift){
		$line .= "\n";
		print $fh $line;
	}
	close($fh);
}

sub printusage {
	print "usage: 'dir' prints currently saved directories\n";
	print "dir <NUMBER> prints directory saved NUMBER\n";
	print "dir <COMMAND> [NUMBER] [PATH]\n";
	print "COMMAND := a | s | d | c\n";
	print "a := add [PATH] | current working directory\n";
	print "s := set [NUMBER] [PATH] | current working directory\n";
	print "d := delete <NUMBER>\n";
	print "c := clear\n";
}
