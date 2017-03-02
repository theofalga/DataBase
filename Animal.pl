#!/usr/bin/perl
#Projet Base de Donnees et Perl - M1 Bioinformatique
#Theo Falgarone / Tristan Maunier

use strict;
use Try::Tiny;
use DBI;
#Connection à la base de donnée
my $dbh = DBI->connect("DBI:Pg:dbname=tmaunier;host=dbserver",
"tmaunier", "",{'RaiseError' =>1});
try {
my $sth = $dbh ->prepare("Alter Table Animal ADD Constraint pkID Primary Key(IdAnimal)") ;
}catch{
	$sth->finish;
	print "erreur\n" ;
	if ($_ eq 0)
	{
		my $num = $sth -> execute() ;
	}
};

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
	push(@Vaccin1,$8) ;
	push(@Vaccin2,$9) ;
	push(@Vaccin3,$10) ;
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
=cut
