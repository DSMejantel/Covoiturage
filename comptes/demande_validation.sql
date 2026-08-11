--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('index.json') AS properties;


set result = sqlpage.send_mail(json_object(
    'to', 'mairie-de-barjac48@wanadoo.fr',
    'subject', 'Demande de suppression de compte',
    'body', 'Bonjour,'||:username||' a demandé la suppression de son compte Barjac Mobilités.'
))

set result = sqlpage.send_mail(json_object(
    'to', :courriel,
    'subject', 'Demande de suppression de compte',
    'body', 'Bonjour '||:username||', votre demande de suppression du compte Barjac Mobilités a été transmise.'
))

select 'alert' as component,
    case when json_extract($result, '$.status') = 'accepted' then 'Validé !' else 'Problème !' end as title,
    case when json_extract($result, '$.status') = 'accepted' then 'success' else 'danger' end as color,
    case when json_extract($result, '$.status') = 'accepted' then 'La demande a bien été transmise. Vous en recevrez une copie.' else 'Erreur dans l''envoi du message' end as description;
select    'Retour'  as title,
     '/comptes/user.sql'  as link;






