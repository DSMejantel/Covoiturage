 SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
        
SET libre=(SELECT places FROM resa WHERE id=$delete_id)

DELETE FROM resa
WHERE id = $delete_id;

UPDATE trajets 
SET places=places+$libre
WHERE id=$trajet_id

set result = sqlpage.send_mail(json_object(
    'to', (SELECT courriel FROM user_info JOIN trajets on user_info.username=trajets.user_id WHERE trajets.id=$trajet_id) ,
    'subject', 'Réservation annulée sur BARJACar',
    'body', 'Un passager s''est désincrit de l''offre de covoiturage pour '||(SELECT arrivee FROM trajets WHERE id=$trajet_id)||' le '||(SELECT strftime('%d/%m/%Y',jour) FROM trajets WHERE id=$trajet_id)||'.'
));
    
    select 'redirect' AS component,
    '/index.sql?tab=3&stab=2' AS link;
    

