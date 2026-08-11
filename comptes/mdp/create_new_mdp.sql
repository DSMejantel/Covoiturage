
--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('connexion.json') AS properties;

SELECT 'alert' as component,
    'Mot de passe changé !' as title,
    'Pour information,  le mot pour '|| $username ||' a bien été changé.' as description_md,
    'succes' as icon,
    'green' as color;
    


