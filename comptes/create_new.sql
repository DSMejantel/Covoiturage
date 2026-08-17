-- Vérification des doublons de noms ou de courriel
SELECT 'redirect' AS component, 'create_new_welcome_message.sql?error='||1||'&username=' || :username AS link WHERE EXISTS (
    SELECT 1 
    FROM user_info 
    WHERE username = :username
);
           
    INSERT INTO user_info (username, password_hash, nom, prenom, groupe, tel, courriel, consentement)
    VALUES (REPLACE(:username, ' ', ''), sqlpage.hash_password(:password), :nom, :prenom, 1, NULLIF(:tel,''), :courriel, 1)
    
    SELECT 'redirect' AS component,
    'create_new_welcome_message.sql?username=' || :username AS link;

-- If we are still here, it means that the user was not created
-- because the username was already taken.
SELECT 'redirect' AS component, 'create_new_welcome_message.sql?error&username=' || :username AS link;

