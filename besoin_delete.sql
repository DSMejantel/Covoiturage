 SELECT 'redirect' AS component,
        '/comptes/signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
        

DELETE FROM besoins
WHERE id = $id;

    
    select 'redirect' AS component,
    '/comptes/user.sql?tab=Mes besoins' AS link;
    

