--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('connexion.json') AS properties;

SET code=(SELECT (abs(random()) % 900000) + 100000)

-- Formulaire
SELECT 'form' AS component,
    'Je renseigne mon nom adresse de courriel' AS title,
'create_validation2.sql' AS action,
    'Je demande un nouveau code d''activation' AS validate,
    'green'           as validate_color;

SELECT 'mail' AS name, 'Adresse de courriel' as label, 6 as width, TRUE as required;
    select 'hidden' as type, 'code' as name, $code as value;


