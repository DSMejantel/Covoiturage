 SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
        

DELETE FROM aires
WHERE id = $id;

    
    select 'redirect' AS component,
    '/aires.sql' AS link;
    

