--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('index.json') AS properties;


set result = sqlpage.send_mail(json_object(
    'to', 'mairie-de-barjac48@wanadoo.fr',
    'cc', :courriel,
    'subject', 'Demande aire de covoiturage pour Barjac Mobilités',
    'body', 'Bonjour,'||:username||' a demandé :'||:aire
))

select 'alert' as component,
    case when json_extract($result, '$.status') = 'accepted' then 'Validé !' else 'Problème !' end as title,
    case when json_extract($result, '$.status') = 'accepted' then 'success' else 'danger' end as color,
    case when json_extract($result, '$.status') = 'accepted' then 'La demande a bien été transmise. Vous en recevrez une copie.' else 'Erreur dans l''envoi du message' end as description;
select    'Retour'  as title,
     '/index.sql'  as link;






