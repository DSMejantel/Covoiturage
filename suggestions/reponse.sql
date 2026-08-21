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
    'text' as component,
    TRUE   as article,
    '
> De '||username||'
>
> — '||idee||'
' as contents_md
FROM idees WHERE id=$id;


-- Formulaire
SELECT 'form' AS component,
    '' AS title,
    'idee' as id,
    ''AS validate,
    'teal'           as validate_color;

select  'reponse'   as name, 'textarea' as type, 'Réponse' as label, (SELECT coalesce(reponse,'Pas encore de réponse') FROM idees WHERE id=$id) as value;
select 'switch' as type,  'validation de la proposition' as label, 'validation' as name, CASE WHEN (SELECT validation FROM idees WHERE id=$id) = 1 THEN TRUE ELSE FALSE END as checked, 1 as value;
SELECT 'hidden' as type, 'idee' AS name, $id as value;

    
select 
    'button' as component;
select 
    'reponse_validation.sql' as link,
    'idee'            as form,
    'teal'          as color,
    'Je valide la réponse'    as title;

