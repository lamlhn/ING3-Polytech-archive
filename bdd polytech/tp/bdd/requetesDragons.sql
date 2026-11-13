

-- 1- Noms des dragons qui crachent du feu
select nom from dragon where crache_feu = true ;
--   nom   
---------
-- Smeagol
-- Negueth
-- Bolong
-- Miloch
-- Tarak
-- Solong
--(6 rows)


-- 2 - Liste des dragons femelles dans l’ordre décroissant de leur longueur.
select * from dragon where sexe = 'F' order by longueur desc ;
--   nom   | sexe | longueur | nb_ecailles | crache_feu | ref_type_dragon 
---------+------+----------+-------------+------------+-----------------
-- MissToc | F    |      183 |        2781 | f          |               4
-- Negueth | F    |      128 |        1582 | t          |               3
-- Tarak   | F    |      123 |         851 | t          |               2
--(3 rows)

-- 3 - Nom des dragons amoureux qui crachent le feu
select dragon_aimant from relation join dragon on nom=dragon_aimant 
where crache_feu ;
-- dragon_aimant 
---------------
-- Smeagol
-- Negueth
-- Miloch
-- Tarak
-- Bolong
--(5 rows)


-- 4 - Nom des dragons non amoureux
select nom from dragon where nom not in (select dragon_aimant from relation) ;
--   nom   
---------
-- MissToc
-- Solong
--(2 rows)

-- 5 Liste des couples de noms de dragons qui s’aiment mutuellement en supprimant les doublons
select r1.dragon_aimant, r1.dragon_aime from relation r1, relation r2  
where r1.dragon_aime = r2.dragon_aimant and r1.dragon_aimant=r2.dragon_aime 
      and r1.dragon_aimant > r1.dragon_aime ;
-- dragon_aimant | dragon_aime 
---------------+-------------
-- Negueth       | Miloch
-- Tarak         | Bolong
--(2 rows)

-- 6 Noms des dragonnes qui sont aimées par tous les dragons machos.
select nom from dragon d1 
where d1.sexe='F' and
      not exists (select * from dragon d2 join type_dragon on ref_type_dragon=id_type_dragon 
                  where libelle = 'macho' and 
                        not exists(select * from relation 
                                   where dragon_aimant=d2.nom and dragon_aime=d1.nom) ) ;
  nom  
-------
 Tarak
(1 row)

-- 7 Liste des produits de plus de 10 calories consommés par les dragons mâles crachant du
-- feu.
select distinct produit from nourriture join repas on ref_nourriture=produit join dragon on ref_dragon=nom where calories >=10 and sexe='M' and crache_feu ;
--  produit  
-----------
-- oeuf
-- cacahuete
-- orange
-- poisson
-- (4 rows)

-- 8 Quel est le nombre de calories consommées par chaque dragon lors d’un repas ? 
-- On affichera le nom du dragon, le produit ingurgité et le nombre de calories consommées. 
-- Classer dans l’ordre croissant du total des calories.
 select ref_dragon, quantite*calories as somme_calories, ref_nourriture from repas join nourriture on ref_nourriture=produit order by somme_calories desc ;
-- ref_dragon | somme_calories | ref_nourriture 
------------+----------------+----------------
-- Smeagol    |          10000 | cacahuete
-- Miloch     |           1000 | cacahuete
-- Nessie     |            700 | poisson
-- Tarak      |            250 | orange
-- Miloch     |            159 | ver
-- Negueth    |            150 | orange
-- Smeagol    |            112 | pomme
-- Solong     |             90 | oeuf
-- Tarak      |             70 | pomme
-- Bolong     |             60 | oeuf
-- Solong     |             50 | orange
-- Solong     |             35 | poisson
-- Negueth    |             15 | oeuf
-- (13 rows)

-- 9 Afficher pour chaque dragon, le nombre de produits qu'il mange
select ref_dragon, count(*) as nb  from repas group by ref_dragon; 
--ref_dragon | nb 
------------+----
-- Solong     |  3
-- Smeagol    |  2
-- Miloch     |  2
-- Nessie     |  1
-- Bolong     |  1
-- Tarak      |  2
-- Negueth    |  2
-- (7 rows)

--10 Afficher les noms de dragons qui sont aimé par au moins deux autres dragons
select dragon_aime, count(*) from relation group by dragon_aime having count(*) > 1 ;
-- dragon_aime | count 
-------------+-------
-- Tarak       |     3
-- Negueth     |     2
-- (2 rows)


