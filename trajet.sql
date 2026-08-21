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

-- Nouveau trajet   
select 
    'divider' as component,
    'Ajouter un trajet'   as contents
    WHERE $tab=1;
      
SELECT 
    'form' as component,
    'trajet_ajout_carte.sql' as action,
    'trajet_ajout_carte' as id,
    ''  as validate;
SELECT 'hidden' as type, 'user' as name, user_info.username as value FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session');
SELECT 'Date' AS label, 'dep_date' AS name, 'date' as type, (select date('now')) as value, 4 as width, TRUE as required;
SELECT 'Heure d''arrivée' AS label, 'heure' AS name, 'time' as type, strftime('%H:%M','now') as value, 4 as width, TRUE as required;
SELECT 'places' AS name, 'places' AS label, 'number' AS type, 1 AS step, 1 as min, 4 as width, 1 as value, TRUE as required;
select 'user_search_D' as name, 'Ville ou adresse de DÉPART' as label, 'Code postal adresse, COMMUNE' as placeholder, TRUE as required; 
select 'user_search_A' as name, 'Ville ou adresse d''ARRIVÉE' as label, 'Code postal adresse, COMMUNE' as placeholder, TRUE as required;

   
select 
    'button' as component,
    'center' as justify;    
select 
    'trajet_ajout_carte' as form,
    'trajet_ajout_carte.sql' as link,
    'orange'    as outline,
    'world' as icon,
    'Proposer'  as title; 



