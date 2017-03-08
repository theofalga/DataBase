#!/usr/bin/perl
#Projet Base de Donnees et Perl - M1 Bioinformatique
#Theo Falgarone / Tristan Maunier

use strict;
use Try::Tiny;
use DBI;


sub Table_Animal
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' => 1}) or warn $DBI::errstr ;
	my $refIdAnimal = shift ;
	my @IdAnimal = @{$refIdAnimal};
	my $refNomAnimal = shift ;
	my @NomAnimal = @{$refNomAnimal} ;
	my $refEspece = shift ;
	my @Espece = @{$refEspece} ;
	my $refSexe = shift ;
	my @Sexe = @{$refSexe} ;
	my $refCouleur = shift ;
	my @Couleur = @{$refCouleur} ;
	my $refAnneeNaissance = shift ;
	my @AnneeNaissance = @{$refAnneeNaissance} ;
	for (my $i=0 ; $i<=$#IdAnimal ; $i++)
	{
		my $sth = $dbh ->prepare("Insert Into Animal Values($IdAnimal[$i],'$NomAnimal[$i]','$Espece[$i]','$Sexe[$i]','$Couleur[$i]',$AnneeNaissance[$i])") ;
		my $num = $sth -> execute() or warn $DBI::errstr if $DBI::err ;
		$sth->finish ;
		print "Success\n" ;
	}
	$dbh->disconnect();
}

sub Table_Medical
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'RaiseError' =>1});
	my $refIdAnimal = shift ;
	my @IdAnimal = @{$refIdAnimal};
	my $refSterilise = shift ;
	my @Sterilise = @{$refSterilise} ;
	my $refVaccin1 = shift ;
	my @Vaccin1 = @{$refVaccin1} ;
	my $refVaccin2 = shift ;
	my @Vaccin2 = @{$refVaccin2} ;
	my $refVaccin3 = shift ;
	my @Vaccin3 = @{$refVaccin3} ;
	for (my $i=0 ; $i<=$#IdAnimal ; $i++)
	{
		my $sth = $dbh ->prepare("Insert Into Medical Values($IdAnimal[$i],'$Sterilise[$i]', $Vaccin1[$i],$Vaccin2[$i],$Vaccin3[$i])") ;
		my $num = $sth -> execute() ;
		$sth->finish;
		print "Success\n" ;
	}
	$dbh->disconnect();
}

sub Table_Proprietaire
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'RaiseError' =>1}) or warn $DBI::errstr;
	my $refTelephone = shift ;
	my @Telephone = @{$refTelephone};
	my $refIdAnimal = shift ;
	my @IdAnimal = @{$refIdAnimal} ;
	my $refNom = shift ;
	my @Nom = @{$refNom} ;
	my $refPrenom = shift ;
	my @Prenom = @{$refPrenom} ;
	for (my $i=0 ; $i<=$#IdAnimal ; $i++)
	{
		my $sth = $dbh ->prepare("Insert Into Proprietaire Values($Telephone[$i],$IdAnimal[$i],'$Nom[$i]','$Prenom[$i]')") ;
		my $num = $sth -> execute() or warn $DBI::errstr ;
		$sth->finish;
		print "Success\n" ;
	}
	$dbh->disconnect();
}

sub Table_Adresse
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'RaiseError' =>1});
	my $refTelephone = shift ;
	my @Telephone = @{$refTelephone};
	my $refRue = shift ;
	my @Rue = @{$refRue} ;
	my $refCodePostal = shift ;
	my @CodePostal = @{$refCodePostal} ;
	for (my $i=0 ; $i<=$#Telephone ; $i++)
	{
		my $sth = $dbh ->prepare("Insert Into Adresse Values($Telephone[$i],'$Rue[$i]',$CodePostal[$i])") ;
		my $num = $sth -> execute() ;
		$sth->finish;
		print "Success\n" ;
	}
	$dbh->disconnect();
}

sub Table_Commune
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'RaiseError' =>1});
	my $refCodePostal = shift ;
	my @CodePostal = @{$refCodePostal};
	my $refNomCommune = shift ;
	my @NomCommune = @{$refNomCommune} ;
	my $refNbHabitants = shift ;
	my @NbHabitants = @{$refNbHabitants} ;
	my $refCodeDepartement = shift ;
	my @CodeDepartement = @{$refCodeDepartement} ;
	for (my $i=0 ; $i<=$#CodePostal ; $i++)
	{
		my $sth = $dbh ->prepare("Insert Into Adresse Values($CodePostal[$i],'$NomCommune[$i]',$NbHabitants[$i],$CodeDepartement[$i])") ;
		my $num = $sth -> execute() ;
		$sth->finish;
		print "Success\n" ;
	}
	$dbh->disconnect();
}


#################### MAIN HERE ####################

#Creation des listes avec un parser
my $file = "Animaux.csv" ;
open (SRC, $file) || die "Fichier introuvable" ;
my @IdAnimal;
my @NomAnimal;
my @TypeAnimal;
my @Couleur;
my @Sexe;
my @Sterilise;
my @AnneeNaissance;
my @Vaccin1;
my @Vaccin2;
my @Vaccin3;
my @Telephone;
my @Nom;
my @Prenom;
my @Rue;
my @CodePostal;
my @Commune;
my @NbHabitantsCommune;
my @CodeDepartement ;
<SRC> ;
while(<SRC>)
{
	chomp ;
	$_ =~ m/(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.*),(.*),(.*),(.+),(.+),(.+),(.+),(.+),(.+),(.+),(.+)/ ;
	push(@IdAnimal,$1) ;
	push(@NomAnimal,$2) ;
	push(@TypeAnimal,$3) ;
	push(@Couleur,$4) ;
	push(@Sexe,$5) ;
	push(@Sterilise,$6) ;
	push(@AnneeNaissance,$7) ;
	if ($8 eq "")
	{
		push(@Vaccin1, 0) ;
	}
	else
	{
		push(@Vaccin1,$8) ;
	}
	if ($9 eq "")
	{
		push(@Vaccin2, 0) ;
	}
	else
	{
		push(@Vaccin2,$9) ;
	}
	if ($10 eq "")
	{
		push(@Vaccin3, 0) ;
	}
	else
	{
		push(@Vaccin3,$10) ;
	}
	push(@Telephone,$11) ;
	push(@Nom,$12) ;
	push(@Prenom,$13) ;
	push(@Rue,$14) ;
	push(@CodePostal,$15) ;
	push(@Commune,$16) ;
	push(@NbHabitantsCommune,$17) ;
	push(@CodeDepartement,$18) ;
}
close (SRC) ;

#Connection à la base de donnée
my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'RaiseError' =>1});


Table_Proprietaire(\@Telephone,\@IdAnimal,\@Nom,\@Prenom) ;

#Deconnection de la base de donnée
$dbh->disconnect();
#Affichage de la liste pour verifier



=head
sub menu
{
	print"\n";
	print"		Que voulez vous faire ?\n";
	print"\n";
	print"Tapez 1 pour Ajouter un nouvel animal\n";
	print"Tapez 2 pour Modifier l'adresse d'un proprietaire\n";
	print"Tapez 3 pour Enregistrer un nouveau vaccin\n";
	print"Tapez 4 pour Afficher tous les chats\n";
	print"Tapez 5 pour Afficher les animaux de type X ayant moins de Y annees\n";
	print"Tapez 6 pour Afficher le nombre moyen d'animaux par proprietaire\n";
	print"Tapez 7 pour Afficher les proprietaires qui ont plus de trois animaux\n";
	print"Tapez 8 pour Pour chaque commune, Afficher le nombre de proprietaires distincts\n";
	print"Tapez 9 pour Pour chaque commune, Afficher le nombre total d'animaux\n";
	print"Tapez 0 pour quitter\n";
}
my $answer=-8;
print"		Bonjour\n";
while ($answer !=0)
{
	menu();
	$answer = <STDIN>;
	chomp($answer);
	if ($answer eq 1)
	{
		
	}
	if ($answer eq 2)
	{
		
	}
	if ($answer eq 3)
	{
		
	}
	if ($answer eq 4)
	{
		
	}
	if ($answer eq 5)
	{
		
	}
	if ($answer eq 6)
	{
		
	}
	if ($answer eq 7)
	{
		
	}
	if ($answer eq 8)
	{
		
	}
	if ($answer eq 9)
	{
		
	}
}
