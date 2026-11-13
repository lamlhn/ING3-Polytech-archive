

-- 1. Tuples de la table 'film'
select * from film ;

-- 2. Nom et prenom des abonnés, Une seule colonne en majuscule
select upper (nomab || ' ' || prenomab) as nom_prenom from abonne ;

-- 3. titres des films antérieurs à 2005 
select titre from film where anneeProduction < 2005 ;

-- 4 titres des films parus entre 2005 et 2010 triés par ordre alpha
select titre, anneeProduction from film where anneeProduction between 2005 and 2010 order by titre ;

-- 5 liste des films dont le titre commence par 'p'
select * from film where titre like 'p%' or titre like 'P%' ;

-- 6 film dont le titre contient 'se'
select * from film where titre like '%se%' ;

-- 7 libelle des catégories dont font partie les films présents dans la base
select libelle from categorie where ncat in (select ncat from film) ;

select distinct c.libelle from categorie c join film f on c.ncat=f.ncat ;

-- 8 nombre de catégories différentes dont font partie les films présents dans la base


select count(distinct ncat) from film f;

--9 nombre de films par categorie
select ncat, count(*) from film group by ncat ;

--10 nombre moyen d'emprunts des abonnés
-- sol1
select avg(nbre) from (select count(*) as nbre,nab from emprunt group by nab) as NbemprAbonnes ;
-- sol2
with NbemprAbonnes as (select count(*) as nbre,nab from emprunt group by nab)
select avg(nbre) from NbemprAbonnes

select (count(*)::float / count(distinct nab)::float) as NbemprAbonnes from emprunt;

--11 titre des films classés dans la catégorie 'Drame' 
select titre from film join categorie on film.ncat=categorie.ncat 
where  libelle = 'Drame';

-- 12 titre et année des films de 'Tim Burton'
select titre, anneeProduction from film where realisateur= 'Tim Burton' ;

-- 13 nombre de films réalisés par 'Clint Eastwood'
select count(*) from film where realisateur='Clint Eastwood' ;

--14 liste des films de Woody Allen avec pour chaque film, le nombre de dvd correspondant
select titre, count(ndvd) from film join dvd on dvd.nfilm=film.nfilm where realisateur='Woody Allen'
group by film.nfilm,titre ;

--15 liste des films dont on possède plusieurs dvd dans la base
select titre, count(ndvd) from film join  dvd on dvd.nfilm=film.nfilm 
group by film.nfilm,titre having count(ndvd)>1;

--16 liste des films avec le nombre de dvd correspondant qu'on possède
select titre, count(ndvd) from film left join dvd on dvd.nfilm=film.nfilm 
group by film.nfilm,titre ;

--17 noms et prénoms des abonnés ayant emprunté 'Pulp Fiction'
select distinct nomab, prenomab 
  from abonne join emprunt on emprunt.nab=abonne.nab 
    join dvd on emprunt.ndvd=dvd.ndvd
    join film on dvd.nfilm=film.nfilm 
  where titre='Pulp Fiction' ;

--18 liste des films des catégories 'Drame' et 'Action'
select distinct titre from film join categorie on film.ncat=categorie.ncat 
where libelle='Drame' or libelle='Action' ;

--19 liste des films empruntés par 'Marie Dupont'
select distinct titre 
from abonne join  emprunt on emprunt.nab=abonne.nab
  join dvd on emprunt.ndvd=dvd.ndvd
  join film on dvd.nfilm=film.nfilm 
where abonne.prenomab='Marie' and abonne.nomab='Dupont' ;

--20 liste des films n'ayant jamais été empruntés
select titre from film where not exists 
  (select * from emprunt join dvd on emprunt.ndvd=dvd.ndvd 
   where  dvd.nfilm=film.nfilm) ;

--21 titre des films de Woody Allen de la catégorie 'Drame'
select titre from film join  categorie on film.ncat=categorie.ncat
where realisateur='Woody Allen' and libelle='Drame' ;

--22 liste des films dont au moins un dvd a été acheté en aout 2009
select titre from film where exists (select * from dvd where anneeAchat=2009 and moisAchat=8 and nfilm=film.nfilm) ;
-- une simple jointure suffit :
select f.* from film f join dvd d on  f.nfilm = d.nfilm
where anneeAchat = 2009
and moisAchat = 8;

--23 noms et prénoms des abonnés ayant emprunté un film de Woody Allen et un film de Clint Eastwood
select distinct nomab, prenomab from abonne, emprunt e1, emprunt e2
 where e1.nab=abonne.nab and e2.nab=abonne.nab and 
   e1.ndvd in (select ndvd from dvd, film where dvd.nfilm=film.nfilm and realisateur='Woody Allen')
and
  e2.ndvd in (select ndvd from dvd, film where dvd.nfilm=film.nfilm and realisateur='Clint Eastwood') ;

select distinct(a.nab), a.nomab, a.prenomab from abonne a, emprunt e1, film f1, dvd d1, emprunt e2, film f2, dvd d2
where a.nab = e1.nab  
and e1.ndvd = d1.ndvd
and d1.nfilm = f1.nfilm 
and f1.realisateur = 'Woody Allen'
and a.nab = e2.nab  
and e2.ndvd = d2.ndvd
and d2.nfilm = f2.nfilm
and f2.realisateur = 'Clint Eastwood';

--24 liste des films ayant été empruntés par tous les abonnes
select f.titre from film f
where not exists 
	(select a.* from abonne a
	where not exists 
		(select e.* from emprunt e join dvd d on e.ndvd = d.ndvd
		where a.nab = e.nab
		and f.nfilm = d.nfilm
 )) ;

--25 liste des films dont l'année est antérieure aux années des films réalisés par Tim Burton

select titre from film where anneeProduction < all(select anneeProduction from film
where realisateur='Tim Burton') ;

select f.nfilm from film f
group by nfilm
having max(anneeProduction) < 
	(select min(anneeProduction) from film f1 where realisateur = 'Tim Burton');

--26 liste des films dont on ne possede pas de dvd
select titre from film where nfilm not in (select nfilm from dvd) ;

-- 27. Liste des abonnés ayant empruntés tous les films réalisés par Quentin Tarantino.
select a.* from abonne a 
where not exists 
	(select * from film f
	where f.realisateur = 'Quentin Tarantino'
	and not exists 
		(select * from emprunt e join dvd  d on e.ndvd=d.ndvd
		where f.nfilm = d.nfilm and a.nab = e.nab
		)
);  

-- 28. Titre des films produits en 2008 ou 2009.
select titre from film where anneeProduction=2008 or anneeProduction=2009 ;

-- 29. Liste des films dont au moins un dvd a été acheté l’année de sa production.
select distinct titre from film f where 
  exists(
    select * from dvd where anneeAchat=f.anneeProduction and f.nfilm=nfilm) ;

select distinct(f.*) from film f, dvd d
where f.nfilm = d.nfilm 
and f.anneeProduction = d.anneeAchat ;


 
-- 30. Titre des films réalisés ni en 2007, ni en 2008, ni en 2009.
select f.titre from film f
where f.anneeProduction not in (2007, 2008, 2009) ;

-- ou alors 
select f.titre from film f
where f.anneeProduction <> 2007 
and f.anneeProduction <> 2008 
and f.anneeProduction <> 2009 ; 


--31 noms des réalisateurs dont aucun des films contenus dans la base n'a été réalisé en 2009
select distinct realisateur from film where realisateur not in (select distinct realisateur from film where anneeProduction=2009) ;


-- test

select dupont from film ;


