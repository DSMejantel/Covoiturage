SELECT 'redirect' AS component,
        'signin.sql?error' AS link
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
    "url": "https://nominatim.openstreetmap.org/search?format=json&q=' || sqlpage.url_encode(:user_search_D) ||'",
    "headers": {"user-agent": "mobilites_barjac/1.0"} 
}'
set api_results = sqlpage.fetch($url);
set Dlat = CAST($api_results->>0->>'lat' AS FLOAT)
set Dlon = CAST($api_results->>0->>'lon' AS FLOAT)

set url = '{
    "url": "https://nominatim.openstreetmap.org/search?format=json&q=' || sqlpage.url_encode(:user_search_A) ||'",
    "headers": {"user-agent": "mobilites_barjac/1.0"} 
}'
set api_results = sqlpage.fetch($url);
set Alat = CAST($api_results->>0->>'lat' AS FLOAT)
set Alon = CAST($api_results->>0->>'lon' AS FLOAT)



--Message
SELECT 'alert' as component,
    'Aires de covoiturage' as title,
    'Je pense à renseigner les aires sur mon trajet.' 
    as description_md,
    'bus-stop' as icon,
    'green' as color;
    
select 
    'form' as component,
    'trajet' as id,
    ''  as validate,    
    'square-plus' as icon,
    'teal' as color;
select 'user_search_D' as name, 'Départ' as label, :user_search_D as value, TRUE as required;
select 'user_search_A' as name, 'Arrivée' as label, :user_search_A as value, TRUE as required;
SELECT 'hidden' as type, 'username' as name, user_info.username as value FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session');
SELECT 'Date' AS label, 'dep_date' AS name, 'date' as type, (select date(:dep_date)) as value, 4 as width, TRUE as required;
SELECT 'Heure d''arrivée' AS label, 'heure' AS name, 'time' as type, strftime('%H:%M',:heure) as value, 4 as width, TRUE as required;
SELECT 'places' AS name, 'places' AS label, 'number' AS type, 4 as width, :places as value, TRUE as required;
SELECT 'infos' as name, 'Précisions' as label, 12 as width;
SELECT 'hidden' as type, 'dep_Lon' as name, $Dlon as value;
SELECT 'hidden' as type, 'dep_Lat' as name, $Dlat as value;
SELECT 'hidden' as type, 'arr_Lon' as name, $Alon as value;
SELECT 'hidden' as type, 'arr_Lat' as name, $Alat as value;
SELECT 'aire[]' AS name, 'Aires sur le trajet' AS label, TRUE as required, 'Je sélection un ou plusieurs points de rencontre (voir carte ci-dessous)' as placeholder, 'select' AS type, 8 as width, true as multiple, true as dropdown, json_group_array(json_object("label" , covoit, "value", id )) as options FROM (select * FROM aires ORDER BY covoit ASC);
  
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape,
    'center' as justify;
select 
    'trajet_ajout_carte.sql' as link,
    'trajet'            as form,
    'orange'          as outline,
    'refresh-dot' as icon,
    'Je visualise les modifications'         as title;
select 
    'trajet_valider.sql' as link,
    'trajet'         as form,
    'teal'      as color,
    'checks' as icon,
    'J''ai tout vérifié et je valide'         as title;

--Carte
select 'map' as component,
  11 as zoom,
  $Alat as latitude,
  $Alon as longitude;

select :user_search_D as title,
  'home'   as icon,
  'teal' as color,
  $Dlat as latitude,
  $Dlon as longitude;
select :user_search_A as title,
  'car'   as icon,
  'red' as color,
  $Alat as latitude,
  $Alon as longitude;

select 
    'Trajet'      as title,
    JSON('{"type":"LineString","coordinates":[['||CAST($Dlon as DECIMAL)||','||CAST($Dlat as DECIMAL)||'],['||CAST($Alon as DECIMAL)||','||CAST($Alat as DECIMAL)||']]}') as geojson,
    'teal'                    as color,
    :places||' place(s) proposée(s)' as description;
    
select covoit as title,
  covoit_Lat as latitude,
  covoit_Lon as longitude,
      'bus-stop' as icon
      FROM aires;

