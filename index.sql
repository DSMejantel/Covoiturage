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

-- Message si droits insuffisants sur une page
SELECT 'alert' as component,
    'Attention !' as title,
    'Vous ne possédez pas les droits suffisants pour accéder à cette page.' 
    as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $restriction IS NOT NULL;

SELECT 'alert' as component,
    'Attention !' as title,
    'Le code est invalide. Il faut reprendre la prodédure d''inscription'  as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $code_incorrect IS NOT NULL;


-- RGPD effacement données au delà de 30 jours
UPDATE trajets
SET user_id = NULL
WHERE jour <= date('now', '-30 days');

UPDATE resa
SET user_id = NULL
WHERE user_id IS NOT NULL
  AND trajet_id IN (
      SELECT id
      FROM trajets
      WHERE jour <= datetime('now', '-30 days')
  );
  
-- Effacement des demandes dont la date a expirée
DELETE FROM besoins WHERE jour <= datetime('now')

-- Message : validation proposition trajet
SELECT 'alert' as component,
    'Merci !' as title,
    'La proposition de trajet a bien été prise en compte.' 
    as description_md,
    TRUE as dismissible,
    'car' as icon,
    'green' as color
WHERE $validation=1;

-- Message : retour réservation
SELECT 'alert' as component,
    'Merci !' as title,
    'La demande a bien été prise en compte. Sur l''onglet "Mes trajets", tu pourras valider tes demandes de covoiturage pour tes passagers. Ils pourront voir ta confirmation sur leur espace.' 
    as description_md,
    TRUE as dismissible,
    'car' as icon,
    'green' as color
WHERE $booking=1;

SELECT 'alert' as component,
    'Attention !' as title,
    'Cette demande ne peut pas être prise en compte faute de places suffisamment disponibles.' 
    as description_md,
    TRUE as dismissible,
    'car' as icon,
    'red' as color
WHERE $booking=0;

--Dashboard
--Onglets
SET tab=coalesce($tab,'1');
select 'tab' as component, TRUE as center;
select  'Carte'  as title, 'map' as icon, 'index.sql?tab=1' as link, CASE WHEN $tab='1' THEN 'orange' ELSE 'secondary' END as color;
select  'Destinations' as title, 'list' as icon, 'index.sql?tab=2' as link, CASE WHEN $tab='2' THEN 'orange' ELSE 'secondary' END as color;
select  'Mes trajets' as title, 'car' as icon, 'index.sql?tab=3' as link, CASE WHEN $tab='3' THEN 'orange' ELSE 'secondary' END as color where $group_id>0;
select  'Demandes' as title, 'world-question' as icon, 'index.sql?tab=4' as link, CASE WHEN $tab='4' THEN 'orange' ELSE 'secondary' END as color where $group_id>0;
select  'Aires covoiturage' as title, 'bus-stop' as icon, 'index.sql?tab=5' as link, CASE WHEN $tab='5' THEN 'orange' ELSE 'secondary' END as color;


--------------------------------
--- Carte pour non-connectés ---
--------------------------------
select 'map' as component,
  '3.410306' as longitude,
  '44.502909'as latitude,
  11 as zoom WHERE $tab=1 and $group_id=0;
  
select arrivee as title,
  --CASE WHEN (SUM(places)-SUM(reserves))=0 THEN 'car-off' ELSE 'car' END   as icon,
  --CASE WHEN (SUM(places)-SUM(reserves))=0 THEN 'red' ELSE 'green' END as color,
  arr_Lat as latitude,
  arr_Lon as longitude,
CASE 
  WHEN (SUM(places) - SUM(reserves)) <= 0 THEN
    COUNT(DISTINCT id) || CASE WHEN COUNT(DISTINCT id) > 1 THEN ' trajets' ELSE ' trajet' END 
    || ' : 0 plus de place disponible '
  WHEN (SUM(places) - SUM(reserves)) = 1 THEN
    COUNT(DISTINCT id) || CASE WHEN COUNT(DISTINCT id) > 1 THEN ' trajets' ELSE ' trajet' END 
    || ' pour 1 place proposée '
  ELSE
    COUNT(DISTINCT id) || CASE WHEN COUNT(DISTINCT id) > 1 THEN ' trajets' ELSE ' trajet' END 
    || ' pour ' || (SUM(places) - SUM(reserves)) || ' places proposées '
END || '[![](/icons/eye-search.svg)](/index.sql?tab=2&recherche=' || REPLACE(arrivee, ' ', '%20') || ' "je visualise les trajets")' AS description_md,
  '/index.sql?tab=2&recherche='||arrivee as link
      FROM trajets WHERE $tab=1 and datetime(date(jour))>datetime(date('now', '-1 day')) and $group_id=0 GROUP BY arr_Lat, arr_Lon;

SELECT 
    'table'          as component,
    TRUE             as sort,
    TRUE             as search,
    'Date' as markdown,
    'Trajet' as markdown,
    'Pas de trajet proposé pour le moment' as empty_description,
    'Places' as icon,
    coalesce($recherche,'')  as initial_search_value,
    'Filtrer par destination' as search_placeholder
    WHERE $tab=2 and $group_id=0;
    
SELECT
    strftime('%d/%m',jour)||CHAR(10)||CHAR(10)||strftime('%Hh%M',heure) as Date,
    arrivee||CHAR(10)||CHAR(10)||'depuis '||depart as Trajet,
    --(places-reserves) as Places,
    CASE WHEN (places-reserves)>0 THEN 'teal' ELSE 'red'   END as _sqlpage_color,
    CASE WHEN (places-reserves)=3 THEN 'users-group'
    WHEN (places-reserves)=2 THEN 'users'
    WHEN (places-reserves)=1 THEN 'user' ELSE 'car-off' END  as Places
    FROM trajets WHERE $tab=2 and datetime(date(jour))>datetime(date('now', '-1 day')) and $group_id=0;
    

----------------------------------------------
--- Tableau de bord utilisateurs connectés ---
----------------------------------------------
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape WHERE $tab=1 and $group_id>0;
select 
    'Je propose un trajet' as title,
    'trajet.sql' as link,
    'circle-plus' as icon,
    'teal' as outline WHERE $tab=1 and $group_id>0;

-- Cartes des destinations
select 'map' as component,
  '3.410306' as longitude,
  '44.502909'as latitude,
  11 as zoom WHERE $tab=1 and $group_id>0;

select arrivee as title,
  --CASE WHEN (SUM(places)-SUM(reserves))=0 THEN 'car-off' ELSE 'car' END   as icon,
  --CASE WHEN (SUM(places)-SUM(reserves))=0 THEN 'red' ELSE 'green' END as color,
  arr_Lat as latitude,
  arr_Lon as longitude,
CASE 
  WHEN (SUM(places) - SUM(reserves)) <= 0 THEN
    COUNT(DISTINCT id) || CASE WHEN COUNT(DISTINCT id) > 1 THEN ' trajets' ELSE ' trajet' END 
    || ' : 0 plus de place disponible '
  WHEN (SUM(places) - SUM(reserves)) = 1 THEN
    COUNT(DISTINCT id) || CASE WHEN COUNT(DISTINCT id) > 1 THEN ' trajets' ELSE ' trajet' END 
    || ' pour 1 place proposée '
  ELSE
    COUNT(DISTINCT id) || CASE WHEN COUNT(DISTINCT id) > 1 THEN ' trajets' ELSE ' trajet' END 
    || ' pour ' || (SUM(places) - SUM(reserves)) || ' places proposées '
END || '[![](/icons/eye-search.svg)](/index.sql?tab=2&recherche=' || REPLACE(arrivee, ' ', '%20') || ' "je visualise les trajets")' AS description_md,
  '/index.sql?tab=2&recherche='||arrivee as link
      FROM trajets WHERE $tab=1 and datetime(date(jour))>datetime(date('now', '-1 day')) and $group_id>0  GROUP BY arr_Lat, arr_Lon;

--Liste

select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape WHERE $tab=2 and $group_id>0;
select 
    'Je propose un trajet' as title,
    'trajet.sql' as link,
    'circle-plus' as icon,
    'teal' as outline WHERE $tab=2 and $group_id>0;


SELECT 
    'table'          as component,
    TRUE             as sort,
    TRUE             as search,
    'Pas de trajet proposé pour le moment' as empty_description,
    'Date' as markdown,
    'Trajet' as markdown,
    'Places' as markdown,
    'Conducteur' as markdown,
    coalesce($recherche,'')  as initial_search_value,
    'Filtrer par destination' as search_placeholder
    WHERE $tab=2 and $group_id>0;
    
SELECT
    strftime('%d/%m',jour)||CHAR(10)||CHAR(10)||strftime('%Hh%M',heure) as Date,
    '**'||TRIM(arrivee)||'**'||CHAR(10)||CHAR(10)||'depuis '||depart||CHAR(10)||CHAR(10)||'avec '||user_id||CHAR(10) || CHAR(10)||'Infos : '||coalesce(infos,'Pas de précisions particulières') as Trajet,
    CASE WHEN (places-reserves)>0 THEN 'teal' ELSE 'red'   END as _sqlpage_color,
    CASE WHEN (places-reserves)=3 
    THEN '![3 places](/icons/users-group.svg)'
    WHEN (places-reserves)=2 
    THEN '![2 places](/icons/users.svg)'
    WHEN (places-reserves)=1 
    THEN '![1 place](/icons/user.svg)'
    ELSE '![complet](/icons/car-off.svg)' END  as Places,
    CASE 
  WHEN (places - reserves) > 1 THEN 
    '[ ![](/icons/hand-click.svg)](resa.sql?id=' || id || ' "Je réserve (' || (places - reserves) || ' places disponibles)")'
  WHEN (places - reserves) = 1 THEN 
    '[ ![](/icons/hand-click.svg)](resa.sql?id=' || id || ' "Je réserve (1 place disponible)")'
  ELSE NULL 
END AS Places
    FROM trajets WHERE $tab=2 and datetime(date(jour))>datetime(date('now', '-1 day')) and $group_id>0;

    
-- Mes trajets
--Sous-Onglets
SET CONDUCT= (SELECT count(trajets.id) FROM trajets join login_session on login_session.username=trajets.user_id WHERE login_session.id = sqlpage.cookie('session')  and datetime(date(jour))>datetime(date('now', '-1 day')))
SET PASSAG = (SELECT count(resa.id) FROM resa join trajets on trajets.id=resa.trajet_id  join login_session on login_session.username=resa.user_id WHERE login_session.id = sqlpage.cookie('session') and datetime(date(jour))>datetime(date('now', '-1 day')) )
SET STAB_INTRO= (SELECT 1 WHERE $CONDUCT >= $PASSAG);
SET STAB_INTRO= (SELECT 2 WHERE $CONDUCT < $PASSAG);
SET stab=coalesce($stab,coalesce($STAB_INTRO,1));

select 'tab' as component, TRUE as center WHERE $tab=3;
select  'Je suis CONDUCTEUR'  as title, 'steering-wheel' as icon, 'index.sql?tab=3&stab=1' as link, CASE WHEN $stab=1 THEN TRUE ELSE FALSE END as active, CASE WHEN $stab=1 THEN 'orange' ELSE 'secondary' END as color  WHERE $tab=3;
select  'Je suis PASSAGER' as title, 'bus-stop' as icon, 'index.sql?tab=3&stab=2' as link, CASE WHEN $stab=2 THEN TRUE ELSE FALSE END as active, CASE WHEN $stab=2 THEN 'orange' ELSE 'secondary' END as color WHERE $tab=3;

-- conducteur
    
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape WHERE $tab=3 and $stab=1 and $group_id>0;
select 
    'Je propose un trajet' as title,
    'trajet.sql' as link,
    'circle-plus' as icon,
    'teal' as outline WHERE $tab=3 and $stab=1 and $group_id>0;


--Message
SELECT 'alert' as component,
    'Penses-y !' as title,
    TRUE as dismissible,
    'N''oublie pas de valider tes passagers pour confirmer le covoiturage. Un mail leur sera envoyé automatiquement.' 
    as description_md,
    'bus-stop' as icon,
    'green' as color
    FROM login_session join trajets on login_session.username=trajets.user_id  
    WHERE $tab=3 and $stab=1 and login_session.id = sqlpage.cookie('session') GROUP BY user_id ;

/*    
SELECT 
    'table' as component,
    'Pas de trajet en tant que conducteur' as empty_description,
    'Date' as markdown,
    'Trajet' as markdown,
    'Contact' as markdown,
    'Messages' as markdown,
    'Validation' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    TRUE    as sort
    WHERE $tab=3 and $stab=1 ;
SELECT
    strftime('%d/%m',jour)||CHAR(10)||CHAR(10)||strftime('%Hh%M',heure) as Date,
    '**'||TRIM(arrivee)||'**'||CHAR(10)||CHAR(10)||'depuis '||depart as Trajet,
   coalesce(group_concat((resa.user_id||' - '||covoit|| ('[
    ![](/icons/toggle-'||validation||'.svg)
](validation.sql?id='||resa.id||')')||CHAR(10)||CHAR(10)||resa.infos||CHAR(10)||CHAR(10)||(resa.tel||' '||resa.courriel)), CHAR(10)||CHAR(10)),'Aucun passager') as Validation
--    group_concat((resa.infos), CHAR(10)||CHAR(10)) as Messages,
--    group_concat((resa.tel||' - '||resa.courriel), CHAR(10)||CHAR(10)) as Contact
    FROM trajets LEFT JOIN resa on resa.trajet_id=trajets.id JOIN user_info on trajets.user_id=username LEFT JOIN aires on aires.id=resa.aire WHERE trajets.user_id=(SELECT user_info.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session') and  $tab=3 and $stab=1) and datetime(date(jour))>datetime(date('now', '-1 day')) and  $tab=3  and $stab=1 GROUP BY trajets.id ORDER BY jour,heure ASC;
*/
select 
    'columns' as component;
select 
    arrivee as title,
    strftime('%d/%m',jour) as value,
    strftime('%Hh%M',heure) as small_text,
    'car' as icon,
    'teal' as icon_color,
    coalesce(group_concat(('![passager](/icons/user-'||resa.places||'-'||validation||'.svg)'||' '||resa.user_id||' - '||covoit|| ('[
    ![](/icons/toggle-'||validation||'.svg)
](validation.sql?id='||resa.id||')')||CHAR(10)||CHAR(10)||resa.infos||CHAR(10)||CHAR(10)||(resa.tel||' '||resa.courriel)), CHAR(10)||CHAR(10)),'Aucun passager') as description_md,
    'teal'               as value_color
        FROM trajets LEFT JOIN resa on resa.trajet_id=trajets.id JOIN user_info on trajets.user_id=username LEFT JOIN aires on aires.id=resa.aire WHERE trajets.user_id=(SELECT user_info.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session') and  $tab=3 and $stab=1) and datetime(date(jour))>datetime(date('now', '-1 day')) and  $tab=3  and $stab=1 GROUP BY trajets.id ORDER BY jour,heure ASC;
    
-- passager
--select 
--    'divider' as component,
--    'Mes trajets en tant que passager'   as contents WHERE $tab=3;

select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape WHERE $tab=3 and $stab=2 and $group_id>0;
select 
    'Je demande une destination' as title,
    'besoin.sql' as link,
    'circle-plus' as icon,
    'teal' as outline WHERE $tab=3 and $stab=2 and $group_id>0;
/*
SELECT 
    'table' as component,
    'Pas de trajet en tant que passager' as empty_description,
    'Date' as markdown,
    'Trajet' as markdown,
    'Confirmation' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    TRUE    as sort
    WHERE $tab=3 and $stab=2;
SELECT
    CASE WHEN validation=1 THEN '[
    ![](/icons/toggle-1.svg)
    ]()'||'Validé'||CHAR(10)||CHAR(10)||covoit ELSE '[
    ![](/icons/toggle--1.svg)
    ]()'||'En attente'||CHAR(10)||CHAR(10)||covoit END as Confirmation,
    strftime('%d/%m',jour)||CHAR(10)||CHAR(10)||strftime('%Hh%M',heure) as Date,
    '**'||TRIM(arrivee)||'**'||CHAR(10)||CHAR(10)||'depuis '||depart||CHAR(10)||CHAR(10)||'Avec '||trajets.user_id||CHAR(10)||CHAR(10)||coalesce(trajets.infos,'')||CHAR(10)||CHAR(10)||coalesce(user_info.tel,'')||CHAR(10)||CHAR(10)||coalesce(user_info.courriel,'-') as Trajet,
    --covoit as Aire,
    --coalesce(trajets.infos,'-') as Infos,
    --coalesce(user_info.tel,'-')||CHAR(10)||CHAR(10)||user_info.courriel as Contact,
    CASE WHEN validation=1 THEN 'teal' END as _sqlpage_color,
    JSON('{"name":"Annulation","tooltip":"Annuler ma réservation","link":"/resa_delete.sql?trajet_id='||trajets.id||'&delete_id={id}","icon":"trash"}') as _sqlpage_actions,
    resa.id as _sqlpage_id
    FROM trajets JOIN resa on resa.trajet_id=trajets.id JOIN user_info on trajets.user_id=username JOIN aires on aires.id=resa.aire WHERE resa.user_id=(SELECT user_info.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'))  and  $tab=3  and $stab=2 and datetime(date(jour))>datetime(date('now', '-1 day')) and  $tab=3  and $stab=2 ORDER BY jour,heure ASC;
*/
select 
    'columns' as component;
select 
    arrivee as title,
    strftime('%d/%m',jour) as value,
    strftime('%Hh%M',heure) as small_text,
    'bus-stop' as icon,
    'teal' as icon_color,
    json_object('icon','steering-wheel','color','teal','description',trajets.user_id) as item,
    json_object('icon','info-circle','color','teal','description',coalesce(trajets.infos,'pas d''infos')) as item,
        json_object('icon','phone','color','teal','description',coalesce(user_info.tel,'')) as item,
    json_object('icon','mail','color','teal','description',coalesce(user_info.courriel,'-')) as item,
CASE 
  WHEN validation = 1 THEN 
    '![validé](/icons/toggle-1.svg) Validé' || CHAR(10) || CHAR(10) || covoit
  ELSE 
    '![en attente](/icons/toggle--1.svg) En attente' || CHAR(10) || CHAR(10) || covoit
END AS description_md,
    'teal'               as value_color,
    '/resa_delete.sql?trajet_id='||trajets.id||'&delete_id='||resa.id                     as link,
    'Annuler'   as button_text,
    'orange'                  as button_color
    FROM trajets JOIN resa on resa.trajet_id=trajets.id JOIN user_info on trajets.user_id=username JOIN aires on aires.id=resa.aire WHERE resa.user_id=(SELECT user_info.username FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'))  and  $tab=3  and $stab=2 and datetime(date(jour))>datetime(date('now', '-1 day')) and  $tab=3  and $stab=2 ORDER BY jour,heure ASC;
    
--- Les besoins

-- Message : validation proposition trajet
SELECT 'alert' as component,
    'C''est bon !' as title,
    'La demande de destination a bien été prise en compte.' 
    as description_md,
    TRUE as dismissible,
    'map-search' as icon,
    'green' as color
WHERE $tab=4 and $validation=2;


select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape WHERE $tab=4 and $group_id>0;
select 
    'Je demande une destination' as title,
    'besoin.sql' as link,
    'circle-plus' as icon,
    'teal' as outline WHERE $tab=4 and $group_id>0;
select 
    'Je gère mes demandes' as title,
    '/comptes/user.sql?tab=Mes besoins' as link,
    'map-search' as icon,
    'teal' as outline WHERE $tab=4 and $group_id>0;

select 'map' as component,
  '3.410306' as longitude,
  '44.502909'as latitude,
  11 as zoom WHERE $tab=4 and $group_id>0;

select besoin as title,
  besoin_Lat as latitude,
  besoin_Lon as longitude,
      'map-search' as icon,
  '/index.sql?tab=2&recherche='||besoin as link,
    CASE WHEN count(distinct id)>1 THEN count(distinct id)||' demandes pour '||besoin ELSE count(distinct id)||' demande pour '||besoin END as description_md
      FROM besoins WHERE $tab=4 and $group_id>0 GROUP BY besoin;
      
select 'list' as component,
    'Demandes en cours' as title,
    '' as empty_title,
    'Pas de demandes en cours' as empty_description,
    TRUE as compact WHERE $tab=4 and $group_id>0;
select 
    besoin as title,
    'map-search' as icon,
    'le '||strftime('%d/%m/%Y',jour)||' à '||strftime('%Hh%M',heure) as description
      FROM besoins WHERE $tab=4 and $group_id>0;
      
-- Cartes des Aires
select 'map' as component,
  '3.410306' as longitude,
  '44.502909'as latitude,
  11 as zoom WHERE $tab=5;

select covoit as title,
  covoit_Lat as latitude,
  covoit_Lon as longitude,
      'bus-stop' as icon
      FROM aires WHERE $tab=5;
      

      

