SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('index.json') AS properties;


-- Formulaire
SELECT 'form' AS component,
    'Je demande un nouveau point de covoiturage' AS title,
    'aire' as id,
    ''AS validate,
    'green'           as validate_color;

SELECT 'hidden' as type, 'username' AS name, (SELECT login_session.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')) as value;
SELECT 'hidden' as type, 'courriel' AS name, (SELECT user_info.courriel FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')) as value;
select  'aire'   as name, 'textarea' as type, 'Localisation et description' as label;
    
select 
    'button' as component;
select 
    'demande_validation.sql' as link,
    'aire'            as form,
    'green'          as color,
    'J''envoie ma demande'    as title;

