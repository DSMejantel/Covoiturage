SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
--Menu
SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=2;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=3;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id=4;


-- Message si droits insuffisants sur une page
SELECT 'alert' as component,
    'Attention !' as title,
    'Vous ne possédez pas les droits suffisants pour accéder à cette page.' 
    as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $restriction IS NOT NULL;

--Message
SELECT 'alert' as component,
    'Étape de validation' as title,
    'Vérification de la saisie sur la carte. Il est encore possible de modifier les informations.' 
    as description_md,
    'map' as icon,
    'orange' as color;

-- Trajet

set url = '{
    "url": "https://nominatim.openstreetmap.org/search?format=json&q=' || sqlpage.url_encode(:besoin) ||'",
    "headers": {"user-agent": "mobilites_barjac/1.0"} 
}'
set api_results = sqlpage.fetch($url);
set lat = CAST($api_results->>0->>'lat' AS FLOAT)
set lon = CAST($api_results->>0->>'lon' AS FLOAT)


---Carte    
select 'map' as component,
  15 as zoom,
  $lat as latitude,
  $lon as longitude;

select :besoin as title,
  'map-search'   as icon,
  'orange' as color,
  $lat as latitude,
  $lon as longitude;

select 
    'form' as component,
    'destination' as id,
    ''  as validate,    
    'square-plus' as icon,
    'green' as color;
select 'besoin' as name, 'Destination' as label, :besoin as value;
SELECT 'hidden' as type, 'username' as name, user_info.username as value FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session');
SELECT 'hidden' as type, 'courriel' as name, user_info.courriel as value FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session');
SELECT 'hidden' as type, 'besoin_Lon' as name, $lon as value;
SELECT 'hidden' as type, 'besoin_Lat' as name, $lat as value;
SELECT 'Date' AS label, 'dep_date' AS name, 'date' as type, :dep_date as value, 4 as width;
SELECT 'Heure d''arrivée' AS label, 'heure' AS name, 'time' as type, strftime('%H:%M',:heure) as value, 4 as width;
SELECT 'infos' as name, 'Précisions' as label, 12 as width, :infos as value;

  
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape,
    'center' as justify;
select 
    'besoin_ajout_carte.sql' as link,
    'destination'            as form,
    'orange'          as outline,
    'refresh-dot' as icon,
    'Je visualise les modifications'         as title;
select 
    'besoin_valider.sql' as link,
    'destination'         as form,
    'teal'      as color,
    'checks' as icon,
    'J''ai vérifié et je valide'         as title;





