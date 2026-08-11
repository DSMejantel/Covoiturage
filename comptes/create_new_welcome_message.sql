
--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('connexion.json') AS properties;


-- Étapes
select 
    'steps'  as component,
    TRUE     as counter,
    'cyan' as color;
select 
    'Formulaire' as title,
    'forms'             as icon,
    'Données personnelles' as description;
select 
    'Vérification'   as title,
    'eye-check'                 as icon,
    'Confirmer en saisissant le code reçu' as description;
select 
    'Création' as title,
    'Saisie du mot de passe' as description,
    'lock'            as icon;
select 
    'Validation' as title,
    'check'              as icon,
    TRUE                     as active;


--


SELECT 'alert' as component,
    'succes' as icon,
    'green' as color,
     'Validé !' AS title,
   'Pour information,  le nouveau compte '|| $username ||' a bien été créé.' AS description_md
   WHERE $error IS NULL;
select   
   '/index.sql' AS link,
    'Retour au tableau de bord' AS title,
   'green' as color
WHERE $error IS NULL;


SELECT 'alert' as component,
    'succes' as icon,
    'red' as color,
    'Erreur !' AS title,
    'Cet identifiant existe déjà dans la base.' AS description_md
    WHERE $error=1;
SELECT 'alert' as component,
    'succes' as icon,
    'red' as color,
    'Erreur !' AS title,
    'Ce courriel existe déjà dans la base.' AS description_md
    WHERE $error=2;
select
    '/comptes/create.sql' AS link,
    'Recommencer' AS title,
    'orange' as color
WHERE $error IS NOT NULL;
