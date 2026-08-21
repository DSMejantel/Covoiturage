SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SELECT 'redirect' AS component,
        '/index.sql?restriction' AS link
        WHERE $group_id<3;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id=4;

--- Modifier l'aire  
SELECT 
    'form' as component,
    'edit' as id,
    '' as validate;
    
     SELECT 'Aire de covoiturage' AS label, 'covoit' AS name, 'replace-user' as prefix_icon, (SELECT covoit FROM aires WHERE id=$id) as value, TRUE as required;
     SELECT 'Latitude' AS label, 'Lat' AS name, 'world-latitude' as prefix_icon, 4 as width, (SELECT covoit_Lat FROM aires WHERE id=$id) as value, TRUE as required;
     SELECT 'Longitude' AS label, 'Lon' AS name, 'world-longitude' as prefix_icon, 4 as width, (SELECT covoit_Lon FROM aires WHERE id=$id) as value, TRUE as required;

select 
    'button' as component;
select 
    '/aires/aire_update.sql?id='||$id as link,
    'edit'         as form,
    'teal'      as color,
    'Modifier'         as title;
select 
    '/aires.sql' as link,
    'edit'            as form,
    'secondary'          as outline,
    'Annuler'         as title;
