SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
--Menu
SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=2;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=3;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id=4;

        
SELECT 'alert' as component,
    'Annulation de réservation' as title,
    'Le ' || strftime('%d/%m', jour) || ' à ' || strftime('%Hh%M', heure) || ' pour **' || TRIM(arrivee) || '** depuis ' || depart || ' avec ' || user_id as description_md,
     $info AS description_md,
    'alert-circle' as icon,
    'orange' as color
    FROM trajets WHERE id = $trajet_id;
select 
    '/index.sql?tab=3&stab=2'       as link,
    'Je ne change rien' as title,
    'orange'    as color;    
select 
    'resa_delete_update.sql?trajet_id='||$trajet_id||'&delete_id='||$delete_id       as link,
    'Je confirme l''annulation' as title,
    'secondary'    as color;


    

