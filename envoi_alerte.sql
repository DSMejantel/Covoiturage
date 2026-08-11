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


--Mailing des besoins
SELECT sqlpage.send_mail(json_object(
    'to', courriel,
    'subject', 'Alerte Barjac Mobilités',
    'body', 'Bonjour '||user_id||'. Un conducteur propose un trajet vers une de vos destinations demandées :  ' 
            || arrivee || ', le ' || strftime('%d/%m/%Y',pjour) || ' pour une arrivée vers ' || pheure||'.  Vous pouvez consulter https://covoiturage.barjac-en-lozere.fr pour réserver votre place.'
)) FROM alerte WHERE courriel IS NOT NULL AND courriel != ''
