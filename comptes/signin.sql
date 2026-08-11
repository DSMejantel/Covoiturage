--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('connexion.json') AS properties;

SELECT 'alert' as component,
    'Attention' as title,
    'Vous devez vous connecter pour accéder à ce contenu' as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $error IS NOT NULL;



SELECT 'form' AS component,
    'Connexion' AS title,
    'auth' as id,
    '' AS validate;
    --'login.sql' AS action;

SELECT 'username' AS name, 'Identifiant' as label, 4 as width;
SELECT 'password' AS name, 'Mot de passe' as label, 'password' AS type, 'Mot de passe' as placeholder, 4 as width;

select 
    'button' as component;
select 
    'login.sql' as link,
    'auth'            as form,
    'green'          as color,
    'Je me connecte'         as title;
    
SELECT 'alert' as component,
    'Pas encore de compte ?' as description,
    'alert-circle' as icon,
    'orange' as color;
select 
    '/comptes/create.sql'       as link,
    'Je veux créer mon compte' as title,
    'secondary'    as color;
select 
    '/comptes/mdp/create.sql'       as link,
    'J''ai oublié mon mot de passe' as title,
    'orange'    as color;
select 
    '/comptes/admin/signin.sql'       as link,
    'Accès privé' as title,
    'red'    as color
    WHERE EXISTS (
    SELECT 1 
    FROM user_info 
    WHERE activation IS NOT NULL
);


