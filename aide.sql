
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


SELECT 'alert' as component,
    'Pourquoi ce site "BARJACar" ?' as title,
    'Suite à la consultation des habitants de Barjac, la question de faciliter le covoiturage via des aires identifiées et des outils en ligne a été formulée plusieurs fois. Le conseil municipal a donc fait le choix d''un site utilisable gratuitement, accessible avec un téléphone connecté et une adresse mail. Cet un outil entièrement développé par l''équipe municipale de Barjac.' 
    as description_md,
    TRUE as dismissible,
    'bulb' as icon,
    'teal' as color;
  
SELECT 'alert' as component,
    'C''est gratuit ?' as title,
    'Oui : le service BARJACar est proposé gratuitement. Il suffit de s''inscrire en ligne en moins de 2 minutes avec une adresse de courriel.' 
    as description_md,
    TRUE as dismissible,
    'pig-money' as icon,
    'orange' as color;
    
SELECT 'alert' as component,
    'Mes données personnelles sont-elles protégées ?' as title,
    'Oui : les données sont sécurisées sur un serveur en France. Après une double authentification, le mot de passe personnel est crypté. Seuls les autres utilisateurs inscrits peuvent voir votre adresse mail et votre numéro de téléphone. Ce dernier n''est pas obligatoire.' 
    as description_md,
    TRUE as dismissible,
    'shield-check' as icon,
    'teal' as color;
    
SELECT 'alert' as component,
    'Mes données personnelles sont-elles conservées ?' as title,
    'Non : les données liées à vos trajets sont anonymées au bout de 30 jours. Sur demande votre compte pourra être supprimé définitivement.' 
    as description_md,
    TRUE as dismissible,
    'lock' as icon,
    'orange' as color;
    
SELECT 'alert' as component,
    'Comment ça marche ?' as title,
    'Depuis le tableau de bord de BARJACar, vous pouvez consulter les destinations proposées sous forme de carte ou de liste. Vous pouvez également formuler des demandes de trajets. Ensuite à vous de réserver dans la liste ou de valider vos passagers.' 
    as description_md,
    TRUE as dismissible,
    'settings-automation' as icon,
    'teal' as color;


SELECT 'alert' as component,
    'Comment trouver quelqu''un qui peut me transporter avec BARJACar?' as title,
    'Dans le tableau de bord, vous pouvez cliquer sur le repère de la ville qui vous intéresse. Le nombre de trajets et de place apparaît. Si on clique sur le nom de la ville, on est dirigé vers la liste de tous les trajets vers ce lieu.' 
    as description_md,
    TRUE as dismissible,
    'zoom-question' as icon,
    'orange' as color;  
    
SELECT 'alert' as component,
    'Où cliquer pour réserver ?' as title,
    'C''est tout simple : on clique sur la petite main à droite de la destination qui m''intéresse et ensuite on est dirigé vers le formulaire de réservation.' 
    as description_md,
    TRUE as dismissible,
    'hand-click' as icon,
    'teal' as color; 

SELECT 'alert' as component,
    'Comment savoir s''il reste des places?' as title,
    'Le nombre de silouhettes indique le nombre de places disponibles. De plus la destination apparait en vert. S''il ne reste plus de place, la ligne est surlignée en rouge.' 
    as description_md,
    TRUE as dismissible,
    'users-group' as icon,
    'orange' as color; 

SELECT 'alert' as component,
    'Comment puis-je formuler une demande ou un besoin pour un trajet ?' as title,
    'Que ce soit pour un déplacement professionnel, une activité sportive ou un rendez-vous médical, vous pouvez préciser le lieu, le jour et l''heure de ce besoin. Pour cela, deux solutions : depuis le tableau de bord et l''onglet "Les souhaits" ou bien depuis le menu "Mon compte" et le sous-menu "Mes besoins". Dès qu''un trajet correspond à votre souhait (destination, date) vous êtes automatiquement averti par courriel !' 
    as description_md,
    TRUE as dismissible,
    'world-question' as icon,
    'teal' as color;

   
SELECT 'alert' as component,
    'Comment suis-je notifié pour les réservations sur BARJACar ?' as title,
    'Par mail : notre serveur vous envoie instantanément les informations concernant les trajets qui peuvent vous intéresser, les réservations d''un passager ou la validation par le conducteur.' 
    as description_md,
    TRUE as dismissible,
    'mail' as icon,
    'orange' as color;  

SELECT 'alert' as component,
    'Est-ce que je peux utiliser l''application BARJACar même si je n''ai pas de voiture ?' as title,
    'Oui, bien sûr. Sur le tableau de bord, l''onglet "Mes trajets" propose les deux options : Je suis conducteur ou Je suis passager. Bien entendu vous pouvez être parfois conducteur et parfois passager...' 
    as description_md,
    TRUE as dismissible,
    'car-off' as icon,
    'teal' as color;

SELECT 'alert' as component,
    'Est-ce que je peux aider à améliorer BARJACar ?' as title,
    'Oui, bien sûr. Vous pouvez contribuer en proposant des nouveaux points de rencontre pour covoiture. Depuis votre espace personnels, sous l''onglet "Mes suggestions", vous pouvez proposer des améliorations à notre application.' 
    as description_md,
    TRUE as dismissible,
    'heart-handshake' as icon,
    'orange' as color;   
    
