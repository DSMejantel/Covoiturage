 SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));


-- Mise à jour des tables et enregistrement
INSERT INTO trajets (user_id, jour, heure, depart, arrivee, places, reserves, dep_Lon, dep_Lat, arr_Lon, arr_Lat, infos)
VALUES (:username, :dep_date, :heure, :user_search_D, :user_search_A, :places, 0, :dep_Lon, :dep_Lat, :arr_Lon, :arr_Lat, :infos)

INSERT INTO arrets(trajet_id, aire_id)
SELECT
(SELECT last_insert_rowid() FROM trajets) as trajet_id,
CAST(value AS integer) as aire_id from json_each(:aire);

-- Table temporaire
create temporary table if not exists alerte(besoin, user_id, courriel, bjour, bheure, precisions, pjour, pheure, arrivee);
delete from alerte; 
insert into alerte (besoin, user_id, courriel, bjour, bheure, precisions, pjour, pheure, arrivee)
SELECT 
  besoins.besoin as besoin, 
  besoins.user_id as user_id, 
  besoins.courriel as courriel, 
  besoins.jour as bjour,
  besoins.heure as bheure, 
  besoins.precisions as precisions,   
  :dep_date as pjour, 
  :heure as pheure,
  :user_search_A as arrivee
  FROM besoins WHERE :arr_Lon>(besoin_Lon-0.03) AND :arr_Lon<(besoin_Lon+0.03) AND :arr_Lat>(besoin_Lat-0.03) AND :arr_Lat<(besoin_Lat+0.03) AND besoins.jour=:dep_date AND pheure <= bheure;

/*
SELECT 'table' as component;
SELECT * FROM alerte;
*/
-- Exécution muette des envois de mail (via le fichier secondaire)
SET mail_results = sqlpage.run_sql('envoi_alerte.sql'); 


--Mailing des besoins
/*
SELECT sqlpage.send_mail(json_object(
    'to', courriel,
    'subject', 'Alerte Barjac Mobilités',
    'body', 'Bonjour '||user_id||'. Un conducteur propose un trajet vers une de vos destinations demandées :  ' 
            || arrivee || ', le ' || strftime('%d/%m/%Y',jour) || ' pour une arrivée vers ' || heure||'.  Vous pouvez consulter https://covoiturage.barjac-en-lozere.fr pour réserver votre place.'
)) FROM alerte  WHERE courriel IS NOT NULL AND courriel != '';
*/


  
-- Redirection
    select 'redirect' AS component,
    'index.sql?validation=1' AS link;
    

