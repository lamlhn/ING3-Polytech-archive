<?php


function connexionBase($host, $base, $user, $password) {
 $db = pg_connect("host=$host dbname=$base user=$user password=$password") ;
 return $db ;
}




$host = "serveur-etu.polytech-lille.fr" ;
$user = "demo"
$motDePasse = "postgres" ;

$base="gestionServices" ;

$connexion = connexionBase($host, $base, $user,$motDePasse) ;

if ($connexion == FALSE) 
  die ("erreur de connexion :".pg_last_error() ) ;



