#!/usr/bin/perl
#Projet Base de Donnees et Perl - M1 Bioinformatique
#Theo Falgarone / Tristan Maunier

use strict;
use DBI;


#Menu
sub menu
{
	print"\n";
	print"		Que voulez vous faire ?\n";
	print"\n";
	print"Tapez 1 pour Ajouter un nouvel animal\n";
	print"Tapez 2 pour Supprimer un nouvel animal\n";
	print"Tapez 3 pour Modifier l'adresse d'un proprietaire\n";
	print"Tapez 4 pour Enregistrer un nouveau vaccin\n";
	print"Tapez 5 pour Afficher tous les chats\n";
	print"Tapez 6 pour Afficher les animaux de type X ayant moins de Y annees\n";
	print"Tapez 7 pour Afficher le nombre moyen d'animaux par proprietaire\n";
	print"Tapez 8 pour Afficher les proprietaires qui ont plus de trois animaux\n";
	print"Tapez 9 pour Pour chaque commune, Afficher le nombre de proprietaires distincts\n";
	print"Tapez 10 pour Pour chaque commune, Afficher le nombre total d'animaux\n";
	print"Tapez 0 pour quitter\n";
}


#Ajout element table Animal
sub Table_Animal
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' => 0}) ;
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
	my $refTelephone = shift ;
	my @Telephone = @{$refTelephone} ;
	for (my $i=0 ; $i<=$#IdAnimal ; $i++)
	{
		$dbh ->do("Insert Into Animal Values($IdAnimal[$i],'$NomAnimal[$i]','$Espece[$i]','$Sexe[$i]','$Couleur[$i]',$AnneeNaissance[$i],$Telephone[$i])") ;
	}
	$dbh->disconnect();
}

#Ajout element table Medical
sub Table_Medical
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
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
		$dbh ->do("Insert Into Medical Values($IdAnimal[$i],'$Sterilise[$i]', $Vaccin1[$i],$Vaccin2[$i],$Vaccin3[$i])") ;
	}
	$dbh->disconnect();
}

#Ajout element table Proprietaire
sub Table_Proprietaire
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0}) ;
	my $refTelephone = shift ;
	my @Telephone = @{$refTelephone};
	my $refNom = shift ;
	my @Nom = @{$refNom} ;
	my $refPrenom = shift ;
	my @Prenom = @{$refPrenom} ;
	for (my $i=0 ; $i<=$#Telephone ; $i++)
	{
		$dbh ->do("Insert Into Proprietaire Values($Telephone[$i],'$Nom[$i]','$Prenom[$i]')") ;
	}
	$dbh->disconnect();
}

#Ajout element table Adresse
sub Table_Adresse
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
	my $refTelephone = shift ;
	my @Telephone = @{$refTelephone};
	my $refRue = shift ;
	my @Rue = @{$refRue} ;
	my $refCodePostal = shift ;
	my @CodePostal = @{$refCodePostal} ;
	for (my $i=0 ; $i<=$#Telephone ; $i++)
	{
		$dbh ->do("Insert Into Adresse Values($Telephone[$i],'$Rue[$i]',$CodePostal[$i])") ;
	}
	$dbh->disconnect();
}

#Ajout element table Commune
sub Table_Commune
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
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
		$dbh ->do("Insert Into Commune Values($CodePostal[$i],'$NomCommune[$i]',$NbHabitants[$i],$CodeDepartement[$i])") ;
	}
	$dbh->disconnect();
}


#Ajout d'un nouvel animal
sub Ajout_Animal
{
	print "Est-ce que le proprietaire est deja enregistrée [O/N]\n" ;
	my $ans = "" ;
	$ans = <STDIN> ;
	chomp $ans ;
	if (($ans eq 'O') || ($ans eq 'o'))
	{
		New_Animal() ;
	}
	elsif (($ans eq 'N') || ($ans eq 'n'))
	{
		Ajout_Proprietaire() ;
		New_Animal() ;
	}
	else
	{
		print "Veuillez saisir O ou N\n" ;
		Ajout_Animal() ;
	}
}

sub New_Animal
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
	print "Donnez l'ID de l'animal\n" ;
	my $ID = <STDIN> ;
	print "Donnez le nom de l'animal\n" ;
	my $nom = <STDIN> ;
	print "Donnez l'espece de l'animal\n" ;
	my $espece = <STDIN> ;
	print "Donnez le Sexe de l'animal (M/F)\n" ;
	my $sexe = <STDIN> ;
	print "Donnez la couleur de l'animal\n" ;
	my $couleur = <STDIN> ;
	print "Donnez l'annee de naissance de l'animal\n" ;
	my $annee = <STDIN> ;
	print "Donnez le numero de telephone du proprietaire de l'animal\n" ;
	my $tel = <STDIN> ;
	print "L'animal est-il sterilise ? (Oui/Non)\n" ;
	my $sterilise = <STDIN> ;
	$dbh ->do("Insert Into Animal Values($ID,'$nom','$espece','$sexe','$couleur',$annee,$tel)") or warn $DBI::errstr ;
	$dbh ->do("Insert Into Medical Values($ID,'$sterilise',0,0,0)") or warn $DBI::errstr ;
	$dbh->disconnect() ;
}

sub Ajout_Proprietaire
{
	print "Est-ce que la commune dans laquelle vit le proprietaire est deja enregistrée [O/N]\n" ;
	my $ans = <STDIN> ;
	chomp $ans ;
	if (($ans eq 'O') || ($ans eq 'o'))
	{
		New_Proprietaire() ;
	}
	elsif (($ans eq 'N') || ($ans eq 'n'))
	{
		New_Commune() ;
		New_Proprietaire() ;
	}
	else
	{
		print "Veuillez saisir O ou N\n" ;
		Ajout_Proprietaire() ;
	}
}

sub New_Proprietaire
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
	print "Donnez le nom du proprietaire\n" ;
	my $nom = <STDIN> ;
	print "Donnez le prenom du proprietaire\n" ;
	my $prenom = <STDIN> ;
	print "Donnez le numero de telephone du proprietaire\n" ;
	my $tel = <STDIN> ;
	print "Donnez le code postal du proprietaire\n" ;
	my $codepostal = <STDIN> ;
	print "Donnez le nom de la rue du proprietaire\n" ;
	my $rue = <STDIN> ;
	$dbh ->do("Insert Into Proprietaire Values($tel,'$nom','$prenom')") or warn $DBI::errstr ;
	$dbh ->do("Insert Into Adresse Values($tel,'$rue',$codepostal)") or warn $DBI::errstr ;
	$dbh->disconnect() ;
}

sub New_Commune()
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
	print "Donnez le code postal de la commune\n" ;
	my $codepostal = <STDIN> ;
	print "Donnez le nom de la commune\n" ;
	my $nom = <STDIN> ;
	print "Donnez le nombre d'habitants\n" ;
	my $nb = <STDIN> ;
	print "Donnez le code departement\n" ;
	my $codedepartement = <STDIN> ;
	$dbh ->do("Insert Into Commune Values($codepostal,'$nom',$nb,$codedepartement)") or warn $DBI::errstr ;
	$dbh->disconnect() ;
}


#Supprimer un animal
sub Supprimer_Animal
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
	print "Donnez l'ID de l'animal a supprimer\n" ;
	my $ID = <STDIN> ;
	$dbh ->do("Delete From Animal Where IDAnimal = $ID") or warn $DBI::errstr ;
	$dbh->disconnect() ;
}


#Modifier l'adresse d'un proprietaire
sub Update_Adresse
{
	print "Est-ce que la commune dans laquelle vit le proprietaire est deja enregistrée [O/N]\n" ;
	my $ans = <STDIN> ;
	chomp $ans ;
	if (($ans eq 'O') || ($ans eq 'o'))
	{
		New_Adresse() ;
	}
	elsif (($ans eq 'N') || ($ans eq 'n'))
	{
		New_Commune() ;
		New_Adresse() ;
	}
	else
	{
		print "Veuillez saisir O ou N\n" ;
		Update_Adresse() ;
	}
}

sub New_Adresse
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
	print "Donnez le numero de telephone du proprietaire\n" ;
	my $tel = <STDIN> ;
	print "Donnez le nom de la rue\n" ;
	my $rue = <STDIN> ;
	print "Donnez le code postal de la commune\n" ;
	my $codepostal = <STDIN> ;
	$dbh ->do("Update Adresse Set Rue = '$rue',CodePostal='$codepostal' Where Telephone = $tel ") or warn $DBI::errstr ;
	$dbh->disconnect() ;
}

#Modifier les vaccins
sub New_Vaccin
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tfalgarone;host=dbserver",
"tfalgarone", "",{'PrintError' =>0});
	print "Donnez l'ID de l'animal\n" ;
	my $id = <STDIN> ;
	print "Quel vaccin voulez-vous ajouter ? (1/2/3)\n" ;
	my $num = <STDIN> ;
	my $vaccin = "" ;
	if ($num == 1)
	{
		$vaccin = "Vaccin1" ;
	}
	elsif ($num == 2)
	{
		$vaccin = "Vaccin2" ;
	}
	elsif ($num == 3)
	{
		$vaccin = "Vaccin3" ;
	}
	else
	{
		print "Veuillez saisir 1, 2 ou 3" ;
		New_Vaccin() ;
	}
	print "En quelle annee le vaccin a-t-il ete fait ?\n" ;
	my $annee = <STDIN> ;
	$dbh ->do("Update Medical Set $vaccin = $annee Where IDAnimal = $id") or warn $DBI::errstr ;
	$dbh->disconnect() ;
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
"tfalgarone", "",{'PrintError' =>0});

Table_Proprietaire(\@Telephone,\@Nom,\@Prenom) ;
Table_Commune(\@CodePostal,\@Commune,\@NbHabitantsCommune,\@CodeDepartement) ;
Table_Adresse(\@Telephone,\@Rue,\@CodePostal) ;
Table_Animal(\@IdAnimal,\@NomAnimal,\@TypeAnimal,\@Sexe,\@Couleur,\@AnneeNaissance,\@Telephone) ;
Table_Medical(\@IdAnimal,\@Sterilise,\@Vaccin1,\@Vaccin2,\@Vaccin3) ;

my $answer=-8;
print"		Bonjour\n";
while ($answer !=0)
{
	menu();
	$answer = <STDIN>;
	chomp($answer);
	if ($answer eq 1)
	{
		Ajout_Animal() ;
	}
	if ($answer eq 2)
	{
		Supprimer_Animal() ;
	}
	if ($answer eq 3)
	{
		Update_Adresse() ;
	}
	if ($answer eq 4)
	{
		New_Vaccin() ;
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

$dbh->disconnect();
