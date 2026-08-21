SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SELECT 'redirect' AS component,
        '/index.sql?restriction' AS link
        WHERE $group_id<'4';
    
--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('menu.json') AS properties;

select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape;
select 
    'Nouveau compte' as title,
    'comptes_ajout.sql' as link,
    'square-rounded-plus' as icon,
    'green' as outline;
select 
    'Accueil' as title,
    '../index.sql' as link,
    'arrow-back-up' as icon,
    'green' as outline;

--Onglets
SET tab=coalesce($tab,'Utilisateurs');
select 'tab' as component;
select  'Utilisateurs' as title, 'user-circle' as icon, CASE WHEN $tab='Utilisateurs' THEN 1 ELSE 0 END as active, CASE WHEN $tab='Utilisateurs' THEN 'orange' ELSE 'secondary' END as color;
select  'Administrateurs' as title, '' as icon, CASE WHEN $tab='Administrateurs' THEN 1 ELSE 0 END as active, CASE WHEN $tab='Administrateurs' THEN 'orange' ELSE 'secondary' END as color;
select  'Suggestions' as title, 'bulb' as icon, CASE WHEN $tab='Suggestions' THEN 1 ELSE 0 END as active, CASE WHEN $tab='Suggestions' THEN 'orange' ELSE 'secondary' END as color;

-- Liste utilisateurs  
SELECT 'table' as component,
        'Admin' as markdown,
        'Alerte' as icon,
    TRUE    as hover,
    --TRUE    as striped_rows,
    TRUE    as small,
    1 as sort,
    1 as search WHERE $tab='Utilisateurs';
SELECT 
  nom AS Nom,
  prenom AS Prénom,
  username as Identifiant,
  permissions.groupes as Groupe,
  strftime('%d/%m/%Y %H:%M',connexion) as Connexion,
CASE WHEN consentement=0 THEN
'[
    ![](../icons/pencil.svg)
](comptes_edit.sql?id='||username||')[
    ![](../icons/trash.svg)
](comptes_delete.sql?id='||username||')[
    ![](../icons/bell-off.svg)
](comptes_delete_cancel.sql?id='||username||')'
ELSE      '[
    ![](../icons/pencil.svg)
](comptes_edit.sql?id='||username||')[
    ![](../icons/trash.svg)
](comptes_delete.sql?id='||username||')' END as Admin,
  CASE WHEN consentement=0 THEN 'bell-exclamation' END as Alerte,
    CASE WHEN consentement=0 THEN 'red' END as _sqlpage_color
FROM user_info JOIN permissions on user_info.groupe=permissions.groupes_id WHERE groupe<4  AND $tab='Utilisateurs' ORDER BY nom ASC;  


-- Liste   administrateurs
SELECT 'table' as component,
        'Admin' as markdown,
        'Alerte' as icon,
    TRUE    as hover,
    --TRUE    as striped_rows,
    TRUE    as small,
    1 as sort,
    1 as search WHERE $tab='Administrateurs';
SELECT 
  nom AS Nom,
  prenom AS Prénom,
  username as Identifiant,
  permissions.groupes as Groupe,
  strftime('%d/%m/%Y %H:%M',connexion) as Connexion,
     '[
    ![](../icons/pencil.svg)
](comptes_edit.sql?id='||username||')' as Admin,
  CASE WHEN consentement=0 THEN 'bell-exclamation' END as Alerte,
    CASE WHEN consentement=0 THEN 'red' END as _sqlpage_color
FROM user_info JOIN permissions on user_info.groupe=permissions.groupes_id WHERE groupe=4  AND $tab='Administrateurs' ORDER BY nom ASC; 

-- Suggestions   
SELECT 'table' as component,
    'Pas de remarque déposée' as empty_description,
    'Suggestion' as markdown,
    'nom' as Nom,
    'Lu' as markdown,
    'Validation' as markdown
        where $tab='Suggestions';
SELECT 
  idee||CHAR(10)||CHAR(10)||'Réponse : '||coalesce(reponse,'Pas encore de réponse') AS Suggestion,
CASE WHEN lecture=-1 
     THEN '[![](/icons/mail-fast.svg)](/suggestions/lecture.sql?id='||id||')' 
     ELSE '[![](/icons/mail-opened.svg)](/suggestions/lecture.sql?id='||id||')' 
END AS Lu,
  CASE WHEN validation=-1 
  THEN '[![](/icons/square.svg)](/suggestions/validation.sql?id='||id||')' 
  ELSE '[![](/icons/square-check.svg)](/suggestions/validation.sql?id='||id||')' 
  END as Validation,
  '[![](/icons/mail.svg)](/suggestions/reponse.sql?id='||id||')' as Validation
FROM idees where $tab='Suggestions';   
