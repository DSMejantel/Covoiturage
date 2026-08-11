--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('connexion.json') AS properties;

SET courriel=(SELECT courriel FROM user_info WHERE courriel=:mail)
SET username=(SELECT username FROM user_info WHERE courriel=:mail)

set result = sqlpage.send_mail(json_object(
    'to', $courriel,
    'subject', 'Mot de passe oublié pour Barjac Mobilités',
    'body', 'Bonjour '||$username||' : Votre code de validation est : '||:code
))

select 'alert' as component,
    case when json_extract($result, '$.status') = 'accepted' then 'Opération validée' else 'Attention' end as title,
    case when json_extract($result, '$.status') = 'accepted' then 'success' else 'danger' end as color,
    case when json_extract($result, '$.status') = 'accepted' then 'Un code de validation a été envoyé à cette adresse : '||$courriel else 'Cette adresse n''a pas été trouvée dans notre base.' end as description;
select    case when json_extract($result, '$.status') <> 'accepted' then 'Retour' END as title,
    case when json_extract($result, '$.status') <> 'accepted' then '/comptes/mdp/create.sql' END as link;


SELECT 'form' AS component,
    'Validation de mon compte utilisateur' AS title,
'create_verification.sql' AS action,
    'Vérification' AS validate,
    'green'           as validate_color
    WHERE $courriel<>'';

-- Formulaire
SELECT 'hidden' as type, 'username' AS name, $username as value WHERE $courriel<>'';
SELECT 'Code de validation :' AS label, 'validation' AS name, 'password' AS type, 'saisir le code reçu par courriel' as placeholder WHERE $courriel<>'';
select 'hidden' as type, 'code' as name, :code as value WHERE $courriel<>'';


