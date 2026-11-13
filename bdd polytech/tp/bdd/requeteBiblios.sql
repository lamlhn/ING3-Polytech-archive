-- 1 les noms et prénoms des adhérents par ordre alphabétique sur les noms et prénoms

select nom, prenom from adherent order by nom asc, prenom asc ;
   nom    |  prenom  
----------+----------
 Duchemin | Albert
 Duchemin | Mathilde
 Duchemin | Roger
 Lelong   | Berthe
 Revenu   | Andre
 Revenu   | Charles
 Revenu   | Simone
(7 rows)

--2  les noms, prénoms et caution des adhérents  pouvant emprunter au moins 3 livres.

select nom, prenom, caution from adherent join tarif on refTarif=nbEmpruntsAutorises
where nbEmpruntsAutorises >=3 ;
 
    nom    |  prenom  | caution 
----------+----------+---------
 Duchemin | Mathilde |      14
 Duchemin | Albert   |      14
 Revenu   | Charles  |      17
 Duchemin | Roger    |      19
(4 rows)

-- 3 les noms,prénoms des adhérents qui ont des livres non retournés.
select nom,prenom from adherent join emprunt on refAdherent=id
where dateRetour is null ;

   nom    | prenom 
----------+--------
 Lelong   | Berthe
 Duchemin | Roger
(2 rows)

-- 4 les couples des titres de livre empruntés ou ayant été empruntés par un même adhérent.

select l1.titre , l2.titre 
  from livre l1 join exemplaire e1 on e1.reflivre=l1.ISBN join emprunt ep1 on ep1.refExemplaire=e1.id,
              livre l2 join exemplaire e2 on e2.reflivre=l2.ISBN join emprunt ep2 on ep2.refExemplaire=e2.id
  where ep1.refAdherent=ep2.refAdherent and l1.ISBN > l2.isbn;
       titre       |      titre      
------------------+-----------------
 Bases de donnees | LaTeX
 Bases de donnees | Automata Theory

-- 5 Tous les titres de livres et leur nombre d'exemplaires

select titre, count(*) as nb from livre left join exemplaire on reflivre=ISBN 
group by refLivre, titre ;

-- ici left ne change pas le résultat avec l'état de la base fournie
         titre          | nb 
------------------------+----
 Fiabilite des systemes |  2
 LaTeX                  |  3
 Model Checking         |  3
 Automata Theory        |  2
 Bases de donnees       |  3
(5 rows)
-- 6 Les titres de livres empruntés (ou ayant été empruntés) et les noms et prénoms de l'emprunteur.

select titre,nom, prenom 
  from livre join exemplaire e on e.reflivre=ISBN join emprunt on refExemplaire=e.id 
              join Adherent a on a.id=refAdherent;

      titre       |   nom    | prenom 
------------------+----------+--------
 LaTeX            | Duchemin | Albert
 Bases de donnees | Duchemin | Albert
 Bases de donnees | Lelong   | Berthe
 Automata Theory  | Lelong   | Berthe
 Bases de donnees | Duchemin | Roger
 Bases de donnees | Duchemin | Mathilde
(6 rows)

-- 7 Les titres de livres empruntés ou ayant été empruntés par tous les adhérents de nom 'Duchemin'

select titre from livre l 
where not exists (
  select * from adherent a where a.nom='Duchemin'
  and not exists (
    select * from emprunt ep join exemplaire on refexemplaire=id
    where refLivre=l.ISBN and refAdherent=a.id
  )
 )    ;
 
       titre       
------------------
 Bases de donnees
(1 row)

-- 8 les noms,prénoms des adhérents n'ayant jamais emprunté de livres
select nom,prenom from adherent where id not in (select refAdherent from emprunt)
  nom   | prenom  
--------+---------
 Revenu | Andre
 Revenu | Charles
 Revenu | Simone
(3 rows)

--9 les id des  exemplaires empruntés ou ayant été empruntés plus d'une fois.
select refExemplaire from emprunt group by refExemplaire having count(*) > 1
 refexemplaire 
---------------
            12
(1 row)

-- 10  Donner la requête SQL qui augmente les cautions de 5 Euros (à faire en dernier) sauf pour NbEmpruntsAutorises égal à zéro.
update Tarif set caution=caution+5 where NbEmpruntsAutorises <> 0 

Update 6

