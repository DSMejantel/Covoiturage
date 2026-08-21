SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));


 UPDATE resa SET validation=(select validation FROM resa WHERE id=$id)*(-1) WHERE id=$id;
 
 set result = sqlpage.send_mail(json_object(
    'to', (SELECT courriel FROM resa WHERE resa.id=$id) ,
    'subject', 'Mise à jour de votre réservation',
    'body', (CASE WHEN (SELECT validation FROM resa WHERE resa.id=$id)=1 THEN 'Un conducteur a validé votre demande de covoiturage pour ' ELSE 'Votre réservation de covoiturage a été annulée pour ' END)||(SELECT arrivee FROM trajets JOIN resa on trajets.id=resa.trajet_id WHERE resa.id=$id)||' le '||(SELECT strftime('%d/%m/%Y',jour) FROM trajets JOIN resa on trajets.id=resa.trajet_id WHERE resa.id=$id)
));
 
 SELECT 'redirect' as component,
 'index.sql?tab=3' as link;
