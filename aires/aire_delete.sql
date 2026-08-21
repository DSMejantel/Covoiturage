SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));
SELECT 'redirect' AS component,
        '/index.sql?restriction' AS link
        WHERE $group_id<'4';        

DELETE FROM aires
WHERE id = $id;

    
    select 'redirect' AS component,
    '/aires.sql' AS link;
    

