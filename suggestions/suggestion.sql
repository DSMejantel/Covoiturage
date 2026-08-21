SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('index.json') AS properties;


-- Formulaire
SELECT 'form' AS component,
    'Je signale une amélioration à apporter' AS title,
    'idee' as id,
    ''AS validate,
    'teal'           as validate_color;

SELECT 'hidden' as type, 'username' AS name, (SELECT login_session.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')) as value;
SELECT 'hidden' as type, 'courriel' AS name, (SELECT user_info.courriel FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')) as value;
select  'idee'   as name, 'textarea' as type, 'Mon idée' as label;
    
select 
    'button' as component;
select 
    'suggestion_validation.sql' as link,
    'idee'            as form,
    'teal'          as color,
    'J''envoie ma demande'    as title;

