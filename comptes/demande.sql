--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('index.json') AS properties;


select 'alert' as component,
    'Attention !' as title,
    'alert-triangle' as icon,
    --'Une fois la demande prise en compte par nos services, la suppression est définitive !' as description,
    'red' as color;

-- Formulaire
SELECT 'form' AS component,
    '' AS title,
    'supprimer' as id,
    ''AS validate,
    'red'           as validate_color;

SELECT 'hidden' as type, 'username' AS name, (SELECT login_session.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')) as value;
SELECT 'hidden' as type, 'courriel' AS name, (SELECT user_info.courriel FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')) as value;
SELECT 'Une fois la demande prise en compte par nos services, la suppression est définitive !' as value, TRUE as readonly;
    
select 
    'button' as component;
select 
    'user.sql' as link,
    'supprimer'            as form,
    'orange'          as color,
    'Non, je conserve mon compte'    as title;
select 
    'demande_validation.sql' as link,
    'supprimer'            as form,
    'red'          as color,
    'Je confirme la suppression'    as title;

