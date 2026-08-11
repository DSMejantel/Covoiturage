-- Vérification des doublons de noms ou de courriel
SELECT 'redirect' AS component, 'create_new_welcome_message.sql?error='||1||'&username=' || :username AS link WHERE EXISTS (
    SELECT 1 
    FROM user_info 
    WHERE username = :username
);
SELECT 'redirect' AS component, 'create_new_welcome_message.sql?error='||2||'&username=' || :username AS link WHERE EXISTS (
    SELECT 1 
    FROM user_info 
    WHERE courriel = :courriel
);

--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('connexion.json') AS properties;

set result = sqlpage.send_mail(json_object(
    'to', :courriel,
    'subject', 'Enregistrement de votre compte Barjac Mobilités',
    'body', 'Votre code de validation est : '||:code
));

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
    'Confirmer en saisissant le code reçu' as description,
    TRUE                     as active;
select 
    'Création' as title,
    'Saisie du mot de passe' as description,
    'lock'            as icon;
select 
    'Validation' as title,
    'check'              as icon;


--
select 
    'alert'   as component,
    'Vérification de votre adresse de courriel' as title,
    'Un code de validation a été envoyé à cette adresse : '||:courriel as description,
    'mail'   as icon,
    'green'   as color;

SELECT 'form' AS component,
    'Validation de mon compte utilisateur' AS title,
'create_verification.sql' AS action,
    'Vérification' AS validate,
    'green'           as validate_color;

-- Formulaire
SELECT 'hidden' as type, 'username' AS name, :username as value;
SELECT 'Code de validation :' AS label, 'validation' AS name, 'password' AS type, 'saisir le code reçu par courriel' as placeholder;
SELECT 'hidden' as type, 'nom' AS name, :nom as value;
SELECT 'hidden' as type, 'prenom' AS name, :prenom as value;
    SELECT 'hidden' as type, 'tel' AS name, :tel as value;
    SELECT 'hidden' as type, 'courriel' AS name, :courriel as value;
    select 'hidden' as type,  'acceptation' as name, 1 as value;
        select 'hidden' as type, 'code' as name, :code as value;


