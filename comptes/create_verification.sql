SELECT 'redirect' AS component,
        '/index.sql?code_incorrect' AS link
 WHERE :code<>:validation

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
    'lock'            as icon,
    TRUE                     as active;
select 
    'Validation' as title,
    'check'              as icon;


--

select 
    'alert'   as component,
    'Validation correcte' as title,
    'Le code est valide.' as description,
    'check'   as icon,
    'green'   as color;

SELECT 'form' AS component,
    'Finalisation de mon compte utilisateur' AS title,
'create_new.sql' AS action,
    'Créer' AS validate,
    'green'           as validate_color,
    'Recommencer'           as reset;

-- Formulaire
SELECT 'hidden' as type, 'username' AS name, :username as value;
SELECT 'hidden' as type, 'nom' AS name, :nom as value;
SELECT 'hidden' as type, 'prenom' AS name, :prenom as value;
    SELECT 'hidden' as type, 'tel' AS name, :tel as value;
    SELECT 'hidden' as type, 'courriel' AS name, :courriel as value;
    select 'hidden' as type,  'acceptation' as name, 1 as value;
        select 'hidden' as type, 'code' as name, :code as value;
SELECT 'Mot de passe' AS label, 'password' AS name, 'password' AS type, '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*+-_!?&])[A-Za-z\d@$!%*+-_!?&]{8,}$' AS pattern, 'Le mot de passe doit comporter au moins 8 caractères : au moins une lettre minuscule, au moins une lettre majuscule, au moins un chiffre et un caractère spécial parmi $ @ % * + - _ ! ? & ' AS description, 6 as width, TRUE as required;

