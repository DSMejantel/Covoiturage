SELECT 'redirect' AS component,
        '/index.sql?code_incorrect' AS link
 WHERE :code<>:validation

--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('connexion.json') AS properties;



select 
    'alert'   as component,
    'Validation correcte' as title,
    'Le code est valide.' as description,
    'check'   as icon,
    'green'   as color;

SELECT 'form' AS component,
    'Je renouvelle mon mot de passe' AS title,
'create_mdp.sql' AS action,
    'Je valide' AS validate,
    'green'           as validate_color,
    'Recommencer'           as reset;

-- Formulaire
SELECT 'hidden' as type, 'username' AS name, :username as value;
SELECT 'Mot de passe' AS label, 'password' AS name, 'password' AS type, '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*+-_!?&])[A-Za-z\d@$!%*+-_!?&]{8,}$' AS pattern, 'Le mot de passe doit comporter au moins 8 caractères : au moins une lettre minuscule, au moins une lettre majuscule, au moins un chiffre et un caractère spécial parmi $ @ % * + - _ ! ? & ' AS description, 6 as width, TRUE as required;

