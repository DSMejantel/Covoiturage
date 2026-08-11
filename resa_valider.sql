SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

SELECT 'redirect' AS component,
        'index.sql?id='||:id||'&tab=2&booking=0' AS link
 WHERE (SELECT places-coalesce(reserves,0)-(:places) FROM trajets WHERE id=:id)<0;
 
UPDATE trajets SET reserves=coalesce(reserves,0)+(:places) WHERE id=:id;

set result = sqlpage.send_mail(json_object(
    'to', (SELECT courriel FROM user_info JOIN trajets on user_info.username=trajets.user_id WHERE trajets.id=:id) ,
    'subject', 'Réservation à confirmer sur Barjac Mobilités',
    'body', 'Un passager souhaite profiter de l''offre de covoiturage pour '||(SELECT arrivee FROM trajets WHERE id=:id)||' le '||(SELECT strftime('%d/%m/%Y',jour) FROM trajets WHERE id=:id)||'.'
));

INSERT INTO resa(user_id, trajet_id, places, aire, tel, courriel, validation, infos)
SELECT :username, :id, :places, :aire, :tel, :courriel, -1,:infos



SELECT 'redirect' AS component,
        'index.sql?id='||:id||'&tab=2&booking=1' AS link;    
