#!/usr/bin/perl
#Projet Base de Donnees et Perl - M1 Bioinformatique
#Theo Falgarone / Tristan Maunier

use strict;
use DBI;

sub menu
{
	print"\n";
	print"		Que voulez vous faire ?\n";
	print"\n";
	print"Tapez 1 pour Ajouter un nouvel animal\n";
	print"Tapez 2 pour Supprimer un nouvel animal\n";
	print"Tapez 3 pour Modifier l'adresse d'un proprietaire\n";
	print"Tapez 4 pour Enregistrer un nouveau vaccin\n";
	print"Tapez 5 pour Afficher les animaux de type X ayant moins de Y annees\n";
	print"Tapez 6 pour Afficher le nombre moyen d'animaux par proprietaire\n";
	print"Tapez 7 pour Afficher les proprietaires qui ont plus de trois animaux\n";
	print"Tapez 8 pour Pour chaque commune, Afficher le nombre de proprietaires distincts\n";
	print"Tapez 9 pour Pour chaque commune, Afficher le nombre total d'animaux (en SQL)\n";
	print"Tapez 10 Pour chaque commune, Afficher le nombre total d'animaux (en perl)\n";
	print"Tapez 0 pour quitter\n";
}
sub Table_Animal
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' => 0}) ;
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

sub Table_Medical
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
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

sub Table_Proprietaire
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0}) ;
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

sub Table_Adresse
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
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

sub Table_Commune
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
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
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	print "Donnez l'ID de l'animal\n" ;
	my $ID = <STDIN> ;
	chomp $ID;
	print "Donnez le nom de l'animal\n" ;
	my $nom = <STDIN> ;
	chomp $nom;
	print "Donnez l'espece de l'animal\n" ;
	my $espece = <STDIN> ;
	chomp $espece;
	print "Donnez le Sexe de l'animal (M/F)\n" ;
	my $sexe = <STDIN> ;
	chomp $sexe;
	print "Donnez la couleur de l'animal\n" ;
	my $couleur = <STDIN> ;
	chomp $couleur;
	print "Donnez l'annee de naissance de l'animal\n" ;
	my $annee = <STDIN> ;
	chomp $annee;
	print "Donnez le numero de telephone du proprietaire de l'animal\n" ;
	my $tel = <STDIN> ;
	chomp $tel;
	print "L'animal est-il sterilise ? (Oui/Non)\n" ;
	my $sterilise = <STDIN> ;
	chomp $sterilise;
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
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	print "Donnez le nom du proprietaire\n" ;
	my $nom = <STDIN> ;
	chomp $nom;
	print "Donnez le prenom du proprietaire\n" ;
	my $prenom = <STDIN> ;
	chomp $prenom;
	print "Donnez le numero de telephone du proprietaire\n" ;
	my $tel = <STDIN> ;
	chomp $tel;
	print "Donnez le code postal du proprietaire\n" ;
	my $codepostal = <STDIN> ;
	chomp $codepostal;
	print "Donnez le nom de la rue du proprietaire\n" ;
	my $rue = <STDIN> ;
	chomp $rue;
	$dbh ->do("Insert Into Proprietaire Values($tel,'$nom','$prenom')") or warn $DBI::errstr ;
	$dbh ->do("Insert Into Adresse Values($tel,'$rue',$codepostal)") or warn $DBI::errstr ;
	$dbh->disconnect() ;
}

sub New_Commune()
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	print "Donnez le code postal de la commune\n" ;
	my $codepostal = <STDIN> ;
	chomp $codepostal;
	print "Donnez le nom de la commune\n" ;
	my $nom = <STDIN> ;
	chomp $nom;
	print "Donnez le nombre d'habitants\n" ;
	my $nb = <STDIN> ;
	chomp $nb;
	print "Donnez le code departement\n" ;
	my $codedepartement = <STDIN> ;
	chomp $codedepartement;
	$dbh ->do("Insert Into Commune Values($codepostal,'$nom',$nb,$codedepartement)") or warn $DBI::errstr ;
	$dbh->disconnect() ;
}


#Supprimer un animal
sub Supprimer_Animal
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
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
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
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
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
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
sub Affiche_Html
{
	open (RESULT, ">projet_perl.html");
	print RESULT "
	<!DOCTYPE html>
	<HTML>
 	<HEAD>
  	<meta charset=\"utf-8\" />
	<TITLE>Projet Perl \/ SQL Falgarone Maunier</TITLE>
	<link href=\"projet_perl.css\" rel=\"stylesheet\"/>
 	</HEAD>
 	<BODY>
 	<section>
	<center>
	<h1> Projet Perl/SQL </h1>
	<h2> Master 1 Bioinformatique </h2>
	<h2> Theo Falgarone - Tristan Maunier <h2>
	<h3> </h3>
	</section> 
	<section>
	<center>
	<h4> E) Afficher les animaux de type X ayant moins de Y annees </h4>
	<TABLE BORDER=\"1\"> 
  	<CAPTION> Animaux de type X ayant moins de Y annees </CAPTION> 
    <TR> 
 	<TH> ID Animal </TH> 
 	<TH> Nom Animal </TH>
 	<TH> Espece </TH> 
 	<TH> Sexe </TH>
 	<TH> Couleur </TH>
 	<TH> Annee Naissance </TH>
 	<TH> Tel Proprietaire </TH>  
  	</TR>";
  	Affiche_E($_[0]);
  	print RESULT "
  	</TABLE>
	<h4> F) Afficher le nombre moyen d'animaux par proprietaire </h4>
  	<p> Nbr Moy Animaux \/ Proprietaire : ";
  	Affiche_F("Select round(Avg(ct1) ,2)
	From(
	Select Count(*) as ct1
	From Animal
	Group by Telephone) as ct2, Animal");
  	print RESULT "
  	</p> 
	<h4> G) Afficher les proprietaires ayant plus de 3 animaux </h4>
 	<TABLE BORDER=\"1\"> 
  	<CAPTION> Proprietaire Animaux \>3 </CAPTION> 
    <TR> 
 	<TH> Telephone </TH> 
 	<TH> Nom </TH> 
 	<TH> Prenom </TH> 
  	</TR> ";
  	Affiche_G("Select *
	From (Select Telephone as Tel
	From Animal
	Group by Telephone
	Having Count(*)>3)as LOL, proprietaire
	Where Tel=Proprietaire.Telephone");
  	print RESULT "
	</TABLE>
	<h4> H) Pour chaque commune, Afficher le nombre de proprietaires distincts </h4> 
	<TABLE BORDER=\"1\"> 
  	<CAPTION> Nbr proprietaires \/ commune </CAPTION> 
    <TR> 
 	<TH> Nombre proprietaires </TH> 
 	<TH> Commune </TH> 
 	<TH> Code Postal </TH> 
  	</TR>";
  	Affiche_H("Select NbrProprio,NomCommune, CP
	From(Select count(*) as NbrProprio, CodePostal as CP
	From Adresse
	Group by CodePostal) as  Qr1, Commune
	Where CP=Commune.CodePostal");
  	print RESULT"
  	</TABLE>
  	<h4> I) Pour chaque commune, Afficher le nombre total d'animaux </h4> 
	<TABLE BORDER=\"1\"> 
  	<CAPTION> Nbr total animaux \/ commune </CAPTION> 
    <TR> 
 	<TH> Nombre Animaux </TH> 
 	<TH> Commune </TH> 
  	</TR>";
  	Affiche_I("Select Count(IdAnimal) AS NB, Commune.NomCommune
	From(Select Telephone as Tel, CodePostal as Code
	From Adresse
	Group by Telephone, CodePostal) AS Qr1, Animal, Commune
	Where Code=Commune.CodePostal AND Tel=Animal.Telephone
	Group by Commune.NomCommune");
  	print RESULT"
  	</TABLE>
  	</section>
	</BODY>
	</HTML>";
	close (RESULT);
}
sub Affiche_E
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		chomp;
		print RESULT "<TR>";
		print RESULT "<TD> $row[0] </TD>";
		print RESULT "<TD> $row[1] </TD>";
		print RESULT "<TD> $row[2] </TD>";
		print RESULT "<TD> $row[3] </TD>";
		print RESULT "<TD> $row[4] </TD>";
		print RESULT "<TD> $row[5] </TD>";
		print RESULT "<TD> $row[6] </TD>";
		print RESULT "</TR>";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_script_E
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query=$_[0];
	print "\nQuelle espece d'animaux voulez vous afficher ? (Exemple : Chat , Attention à la majuscule)\n";
	my $ans ='';
	$ans =<STDIN>;
	chomp $ans;
	print "Voulez vous ajouter une limite d'age ? [O/N]\n";
	my $ans2 ="";
	$ans2 = <STDIN>;
	chomp $ans2;
	if (($ans2 eq 'O') || ($ans2 eq 'o'))
	{
	print "Afficher les animaux de moins de combien d'annees ? (Exemple : 2 pour les animaux de moins de 2 ans)\n";
	my $age=100;
	$age=<STDIN>;
	my $annee = (2017 - $age); 
	$query = "Select * From Animal Where Espece = '$ans' AND AnneeNaissance <$annee";
	}
	elsif (($ans2 eq 'N') || ($ans2 eq 'n'))
	{
	$query = "Select * From Animal Where Espece = '$ans' ";
	}
	else
	{
		print "Veuillez saisir O ou N\n" ;
	}
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute() or warn $DBI::errstr;
	while (my @row = $sth->fetchrow_array)
	{
		chomp;
		print "ID Animal : $row[0], Nom : $row[1], Espece : $row[2], Sexe : $row[3], Couleur : $row[4], Annee de Naissance : $row[5], Telephone proprietaire : $row[6]\n";
	}
	$sth->finish;
	$dbh->disconnect();
	return $query;
}
sub Affiche_F
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		print RESULT "@row\n";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_script_F
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		print "\nNombre moyen d'animaux par proprietaire : @row\n";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_G
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		chomp;
		print RESULT "<TR>";
		print RESULT "<TD> $row[1] </TD>";
		print RESULT "<TD> $row[2] </TD>";
		print RESULT "<TD> $row[3] </TD>";
		print RESULT "</TR>";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_script_G
{
	print "\nListes des proprietaires ayant plus de 3 animaux : \n";
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		print "Telephone : $row[0], Nom : $row[1], Prenom : $row[2]\n";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_H 
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		chomp;
		print RESULT "<TR>";
		print RESULT "<TD> $row[0] </TD>";
		print RESULT "<TD> $row[1] </TD>";
		print RESULT "<TD> $row[2] </TD>";
		print RESULT "</TR>";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_script_H
{
	print "\nNombre de proprietaires par commune : \n";
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		print "Nbr proprietaires : $row[0], Commune : $row[1], Code Postal : $row[2]\n";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_I
{
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		chomp;
		print RESULT "<TR>";
		print RESULT "<TD> $row[0] </TD>";
		print RESULT "<TD> $row[1] </TD>";
		print RESULT "</TR>";
	}
	$sth->finish;
	$dbh->disconnect();
}
sub Affiche_script_I
{
	print "\nNombre total d'animaux par commune: (SQL)\n";
	my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});
	my $query = $_[0];
	my $sth = $dbh ->prepare($query);
	my $num = $sth->execute();
	while (my @row = $sth->fetchrow_array)
	{
		print "Nbr Animaux : $row[0], Commune : $row[1]\n";
	}
	$sth->finish;
	$dbh->disconnect();
}
#Afficher les animaux par nom de commune en perl
sub nbanimal_commune
{
	my $refIdAnimal = shift ;
	my @IdAnimal = @{$refIdAnimal};
	my $refCommune = shift ;
	my @Commune = @{$refCommune};
	my %nbani_com ;
	for(my $i=0 ; $i<=$#Commune ; $i++)
	{
		$nbani_com{$Commune[$i]}+=1 ;
	}
	return %nbani_com ;
}

sub affiche_nbanimal_commune
{
	print "\nNombre total d'animaux par commune: (Perl)\n";
	my $refIdAnimal = shift ;
	my $refCommune = shift ;
	my %nbani_com = nbanimal_commune($refIdAnimal,$refCommune) ;
	foreach my $key (keys(%nbani_com))
	{
		print "Nbr Animaux : $nbani_com{$key}, Commune : $key \n" ;
	}
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

my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'PrintError' =>0});


Table_Proprietaire(\@Telephone,\@Nom,\@Prenom) ;
Table_Commune(\@CodePostal,\@Commune,\@NbHabitantsCommune,\@CodeDepartement) ;
Table_Adresse(\@Telephone,\@Rue,\@CodePostal) ;
Table_Animal(\@IdAnimal,\@NomAnimal,\@TypeAnimal,\@Sexe,\@Couleur,\@AnneeNaissance,\@Telephone) ;
Table_Medical(\@IdAnimal,\@Sterilise,\@Vaccin1,\@Vaccin2,\@Vaccin3) ;


my $final_query="";
my $quest="Select * From Animal Where Espece = 'Chat' AND AnneeNaissance <2015";
my $answer=-8;
print"\n			Bonjour\n";
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
		$quest = Affiche_script_E($final_query);
		Affiche_Html($quest);
	}
	if ($answer eq 6)
	{
		Affiche_script_F("Select round(Avg(ct1) ,2) From(Select Count(*) as ct1 From Animal Group by Telephone) as ct2, Animal");
	}
	if ($answer eq 7)
	{
		Affiche_script_G("Select * From (Select Telephone as Tel From Animal Group by Telephone Having Count(*)>3)as LOL, proprietaire Where Tel=Proprietaire.Telephone");
	}
	if ($answer eq 8)
	{
		Affiche_script_H("Select NbrProprio,NomCommune, CP From(Select count(*) as NbrProprio, CodePostal as CP From Adresse Group by CodePostal) as  Qr1, Commune Where CP=Commune.CodePostal");
	}
	if ($answer eq 9)
	{
		Affiche_script_I("Select Count(IdAnimal) AS NB, Commune.NomCommune From(Select Telephone as Tel, CodePostal as Code From Adresse Group by Telephone, CodePostal) AS Qr1, Animal, Commune Where Code=Commune.CodePostal AND Tel=Animal.Telephone Group by Commune.NomCommune");
	}
	if ($answer eq 10)
	{
		affiche_nbanimal_commune(\@IdAnimal,\@Commune) ;
	}
	Affiche_Html($quest); #l'argument correspond à la requête définie par la fonction Affiche_script de la question E
}

$dbh->disconnect();

