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

SELECT 
    'form' as component,
    'Valider'  as validate,
    'resa_valider.sql' as action,    
    'user-plus' as icon,
    'teal' as color;
select 'hidden' as type, 'id' as name, $id as value;
select 'hidden' as type, 'username' as name, user_info.username as value FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session');
select 'hidden' as type, 'tel' as name, user_info.tel as value FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session');
select 'hidden' as type, 'courriel' as name, user_info.courriel as value FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session');
SELECT 'places' AS name, 'Places demandées' AS label, 'number' AS type, 4 as width, (SELECT places-coalesce(reserves,0) FROM trajets WHERE id=$id) as max;
SELECT 'aire' AS name, 'Aire de covoiturage' AS label, TRUE as required, 'select' AS type, 8 as width, json_group_array(json_object("label" , covoit, "value", id )) as options FROM (select * FROM aires JOIN arrets on aires.id=arrets.aire_id WHERE arrets.trajet_id=$id GROUP BY id ORDER BY covoit ASC);
SELECT 'infos' as name, 'Précisions' as label, 12 as width;
