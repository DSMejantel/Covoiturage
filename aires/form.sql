SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SELECT 'redirect' AS component,
        '../parametres.sql?restriction' AS link
        WHERE $group_id<3;


--- Saisir une nouvelle modalité de notification  
SELECT 
    'form' as component,
    'Valider' as validate;
    
     SELECT 'Aire de covoiturage' AS label, 'covoit' AS name, 'replace-user' as prefix_icon, TRUE as required;
     SELECT 'Latitude' AS label, 'Lat' AS name, 'world-latitude' as prefix_icon, 4 as width, TRUE as required;
     SELECT 'Longitude' AS label, 'Lon' AS name, 'world-longitude' as prefix_icon, 4 as width, TRUE as required;

