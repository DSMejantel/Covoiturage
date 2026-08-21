SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    
SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

--Onglets
SET tab=coalesce($tab,'Mon profil');
select 'tab' as component;
select  'Mon profil' as title, 'user-circle' as icon, CASE WHEN $tab='Mon profil' THEN 1 ELSE 0 END as active, CASE WHEN $tab='Mon profil' THEN 'orange' ELSE 'secondary' END as color;
select  'Mes besoins' as title, 'map-search' as icon, CASE WHEN $tab='Mes besoins' THEN 1 ELSE 0 END as active, CASE WHEN $tab='Mes besoins' THEN 'orange' ELSE 'secondary' END as color;
select  'Mes suggestions' as title, 'bulb' as icon, CASE WHEN $tab='Mes suggestions' THEN 1 ELSE 0 END as active, CASE WHEN $tab='Mes suggestions' THEN 'orange' ELSE 'secondary' END as color;


---- Ligne d'identification de l'utilisateur et de son mode de connexion
SET user_edit = (SELECT login_session.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));


 -- Boutons administration du profil
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape,
    'start' as justify
    where $tab='Mon profil';
select 
    'Je veux modifier mon Compte' as title,
    'comptes_user.sql' as link,
    'pencil' as icon,
    'teal' as outline
    where $tab='Mon profil';
select 
    'Je veux changer mon mot de passe' as title,
    'comptes_user_password.sql' as link,
    'lock' as icon,
    'teal' as outline
    where $tab='Mon profil';
select 
    'Je veux supprimer mon compte' as title,
    'demande.sql?user_edit='||$user_edit as link,
    'trash' as icon,
    'danger' as outline
    where $tab='Mon profil';
   
-- Profil

SELECT 'table' as component,
    'nom' as Nom,
    'prenom' as Prénom,
    'tel' as Téléphone,
    'courriel' as courriel
        where $tab='Mon profil';
SELECT 
  username as Identifiant,
  nom AS Nom,
  prenom AS Prénom,
  tel as Téléphone,
  courriel as courriel
FROM user_info WHERE username=$user_edit
    and $tab='Mon profil';

-- Mes besoins   
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape WHERE $tab='Mes besoins';
select 
    'Je demande une destination' as title,
    '/besoin.sql' as link,
    'circle-plus' as icon,
    'teal' as outline WHERE $tab='Mes besoins';

select 'list' as component,
    'Mes demandes' as title,
    '' as empty_title,
    'Pas de demandes en cours' as empty_description,
    TRUE                   as compact WHERE $tab='Mes besoins';
select 
    besoin as title,
    'map-search' as icon,
    (SELECT journee FROM semainier WHERE position= strftime('%w',jour))||' '||strftime('%d/%m/%Y',jour)||' à '||strftime('%Hh%M',heure) as description,
  '/besoin_delete.sql?id='||id as delete_link
      FROM besoins WHERE user_id=$user_edit AND $tab='Mes besoins';

select 'map' as component,
  '3.410306' as longitude,
  '44.502909'as latitude,
  11 as zoom WHERE $tab='Mes besoins';

select 
  besoin as title,
  besoin_Lat as latitude,
  besoin_Lon as longitude,
  'map-search' as icon,
  '/index.sql?tab=2&recherche='||besoin as link
      FROM besoins WHERE user_id=$user_edit AND $tab='Mes besoins';
      
-- Mes Suggestions   
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape WHERE $tab='Mes suggestions';
select 
    'Je signale une amélioration à apporter' as title,
    '/suggestions/suggestion.sql' as link,
    'bulb' as icon,
    'teal' as outline WHERE $tab='Mes suggestions';

SELECT 'table' as component,
    'Pas de remarque déposée' as empty_description,
    'Suggestion' as markdown,
    'nom' as Nom,
    'Lu' as markdown,
    'Validation' as markdown
        where $tab='Mes suggestions';
SELECT 
  idee||CHAR(10)||CHAR(10)||'Réponse : '||coalesce(reponse,'Pas encore de réponse') AS Suggestion,
  CASE WHEN lecture =-1 THEN '![lecture](/icons/mail-fast.svg)' ELSE '![lecture](/icons/mail-opened.svg)' END as Lu,
  CASE WHEN validation  =-1 THEN '![passager](/icons/square.svg)' ELSE '![passager](/icons/square-check.svg)' END as Validation
FROM idees WHERE username=$user_edit  and $tab='Mes suggestions';
