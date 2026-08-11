        
    UPDATE user_info 
    SET password_hash=sqlpage.hash_password(:password) WHERE username=:username;

     
    SELECT 'redirect' AS component,
    'create_new_mdp.sql?username=' || :username AS link;



