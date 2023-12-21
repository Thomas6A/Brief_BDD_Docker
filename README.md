# Brief NetStream




## Badges

![Badge Postgresql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

![Badge Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

## TO GET STARTED
Executer la commande :
```cmd
docker compose up
```

Utiliser un SGBD compatible avec postgresql

Il existe deux utilisateurs :

- SuperAdmin : login : thomas et mdp : MySQL08022000

- User: login : User et mdp : mdp

## Description

Projet donné durant la formation cda :

En tant que développeur passionné par le cinéma, vous avez toujours été fasciné par la magie du grand écran.

Vous avez donc envie de créer, vous aussi, votre propre plateforme de streaming sur votre temps libre.

Avant celà, vous avez besoin d'une base de données pour le stockage. Et donc de la concevoir et la mettre en place!

En tant que Concepteur Développeur d'Applications :

Recensement de toutes les données nécessaires dans un dictionnaire de données
Conception grâce à la méthode MERISE : MCD, MLD, MPD
Génération de fixtures pour pouvoir tester la base de données
Ecriture de requêtes SQL
Mise en place de déclencheurs et procédures stockées pour automatiser certaines actions courantes
A vous de jouer 🙂

## Authors

- [@thomas6A](https://github.com/Thomas6A)

## Requêtes

-Les titres et dates de sortie des films du plus récent au plus ancien
```sql
SELECT titre, annee 
FROM Public."Film" 
ORDER BY annee DESC;
```
-Les noms, prénoms et âges des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique
```sql
SELECT nom_acteur, prenom_acteur, DATE_PART('year', now()) - DATE_PART('year', date_naissance) as age 
FROM Public."Acteur" where DATE_PART('year', now()) - DATE_PART('year', date_naissance) < 30
order by nom_acteur;
```
-La liste des acteurs/actrices principaux pour un film donné
```sql
SELECT nom_acteur, prenom_acteur, role, titre 
FROM Public."Joue" j
INNER JOIN Public."Acteur" a
ON j.id_acteur = a.id_acteur
INNER JOIN Public."Film" f
ON f.id_film = j.id_film
where titre = 'film';
```
-La liste des films pour un acteur/actrice donné
```sql
SELECT nom_acteur, prenom_acteur, role, titre 
FROM Public."Joue" j
INNER JOIN Public."Acteur" a
ON j.id_acteur = a.id_acteur
INNER JOIN Public."Film" f
ON f.id_film = j.id_film
where nom_acteur = 'Nom6';
```
-Ajouter un film
```sql
INSERT INTO Public."Film" (titre, duree, annee) 
VALUES ('titre3', 98, 2222);
```

-Ajouter un acteur/actrice
```sql
INSERT INTO Public."Acteur" (nom_acteur, prenom_acteur, date_naissance) 
VALUES ('nom23', 'prenom32', '2012-12-12');
```

-Modifier un film
```sql
UPDATE Public."Film" 
SET titre = 'titre42' 
where titre = 'titre3';
```

-Supprimer un acteur/actrice
```sql
DELETE FROM Public."Acteur" 
where nom_acteur = 'nom23';
```

-Afficher les 3 derniers acteurs/actrices ajouté(e)s
```sql
SELECT nom_acteur, prenom_acteur
FROM Public."Acteur" 
ORDER BY date_ajout_acteur DESC
limit 3;
```