 SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
        
INSERT INTO besoins (besoin, besoin_Lon, besoin_Lat,user_id,courriel, jour, heure, precisions)
VALUES (:besoin, :besoin_Lon, :besoin_Lat, :username, :courriel, :dep_date, :heure, :infos)

    
    select 'redirect' AS component,
    'index.sql?validation=2&tab=4' AS link;
    

