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
    'Données personnelles' as description,
    TRUE                     as active;
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
    'check'              as icon;

    
--
SELECT 'form' AS component,
    'Création de mon compte utilisateur' AS title,
'create_validation.sql' AS action,
    'Créer' AS validate,
    'green'           as validate_color,
    'Recommencer'           as reset;

SET code=sqlpage.random_string(6)

-- Formulaire
SELECT 'username' AS name, 'Identifiant' as label, 4 as width, 'Choisir un identifiant qui sera visible par les autres utilisateurs' as placeholder, TRUE as required;
SELECT 'nom' AS name, 'Nom' as label, 4 as width, TRUE as required;
SELECT 'prenom' AS name, 'Prénom' as label, 4 as width, TRUE as required;
    SELECT 'Téléphone' AS label, 'tel' AS name, 4 as width;
    SELECT 'Courriel' AS label, 'courriel' AS name, 4 as width, TRUE as required;
    select 'hidden' as type, 'code' as name, $code as value;
    select 'switch' as type,  'J''accepte les conditions d''utilisation décrite ci-dessous' as label, 'Vos coordonnées seront visibles uniquement par les utilisateurs connectés. Vous avez un droit d''accès et de rectification de vos données qui sont hébergées sur un serveur situé en France. Les données nominatives liées aux trajets ou aux réservations de covoiturage sont supprimées au bout de 30 jours.'as description, 'acceptation' as name, TRUE as required, FALSE as checked;


