use strict;
use warnings;

fmemSetup();
searchForWallets();
imageMemory();
memorySearch();

sub fmemSetup{

	system("pwd");
	#if sudo install fmem
	chdir("fmem_1.6-0/");
	system("pwd");
	system("make");

	# Revision - if fmem install fails due to kernal headers report 	failure
	system("./run.sh");
	chdir("../");
	system("mkdir InvestigationInfo");
	chdir("InvestigationInfo");
	system("mkdir InvestigationInfo");
	system("pwd");


}
sub searchForWallets{

	print "Searching for Wallets...\n";
	system("find / -name \*.wallet > WalletInfoFound");

}

sub imageMemory{

	#grab an image
	print "Grabbing an Image of Memory...\n";
	system("dd if=/dev/fmem of=investigatedcompmem");
	print "MEMCoin is making sense of all this data...\n";
	system("cat investigatedcompmem | strings > memstrings");

}

sub memorySearch{

	#check to see if password exists
	print "Checking to see if passwords exist...\n";
	my @strings=();
	my $flag = 0;

	my $file = 'memstrings';
	open my $fh, '<', $file or die "Could not open '$file' $!\n";

	system("touch PossiblePasswords");
	open(FILE, ">>PossiblePasswords") || die("Error could not open file");
	 
	while (my $line = <$fh>) 
	{
	   
	   chomp $line;

	   if($flag > 0)
	   {

		print FILE "$line\n";	
		$flag--;
	

	   }

	  #regex not listed
	   if($line =~ '')
	   {
		print FILE "$line \n";
		$flag =3;

	   }

	}

	print "MEMCoin has finished investigation...\n";
}
