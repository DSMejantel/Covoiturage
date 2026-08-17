SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SELECT 'redirect' AS component,
        'index.sql?restriction' AS link
        WHERE $group_id<3;

--Menu
SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id>0 and $group_id<4;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id=4;

--Insertion dans la base
 INSERT INTO aires(covoit, covoit_Lon, covoit_Lat) 
    SELECT :covoit, :Lon, :Lat WHERE :covoit IS NOT NULL;
    

-- Liste et ajout
select 
    'card' as component,
    2  as columns;
select 
    '/aires/form.sql?_sqlpage_embed' as embed;
select 
    '/aires/carte.sql?_sqlpage_embed' as embed;
    
select 'list' as component,
    'Aires' as title,
    '' as empty_title,
    TRUE                   as compact;
select 
covoit as title,
  covoit_Lat as latitude,
  covoit_Lon as longitude,
    '/aires/aire_edit.sql?id='||id as edit_link,
    CASE WHEN NOT EXISTS (
    SELECT 1 
    FROM arrets 
    WHERE arrets.aire_id = aires.id
  ) THEN '/aires/aire_delete.sql?id='||id
  ELSE NULL END as delete_link    
      FROM aires ORDER BY covoit;

 
