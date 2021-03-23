USE vk;

SHOW TABLES;

-- §³§à§Ù§Õ§Ñ§ß§Ú§Ö §ä§Ñ§Ò§Ý§Ú§è§í §Ý§Ñ§Û§Ü§à§Ó
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "§ª§Õ§Ö§ß§ä§Ú§æ§Ú§Ü§Ñ§ä§à§â §ã§ä§â§à§Ü§Ú",
  user_id INT UNSIGNED NOT NULL COMMENT "§ª§Õ§Ö§ß§ä§Ú§æ§Ú§Ü§Ñ§ä§à§â §á§à§Ý§î§Ù§à§Ó§Ñ§ä§Ö§Ý§ñ",
  target_id INT UNSIGNED NOT NULL COMMENT "§ª§Õ§Ö§ß§ä§Ú§æ§Ú§Ü§Ñ§ä§à§â §à§Ò§ì§Ö§Ü§ä§Ñ",
  target_type_id INT UNSIGNED NOT NULL COMMENT "§ª§Õ§Ö§ß§ä§Ú§æ§Ú§Ü§Ñ§ä§à§â §ä§Ú§á§Ñ §à§Ò§ì§Ö§Ü§ä§Ñ",
  like_type TINYINT UNSIGNED NOT NULL COMMENT "§ª§Õ§Ö§ß§ä§Ú§æ§Ú§Ü§Ñ§ä§à§â §ä§Ú§á§Ñ §Ý§Ñ§Û§Ü§Ñ (1 - §Ý§Ñ§Û§Ü, 0 - §Õ§Ú§Ù§Ý§Ñ§Û§Ü)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "§£§â§Ö§Þ§ñ §ã§à§Ù§Õ§Ñ§ß§Ú§ñ §ã§ä§â§à§Ü§Ú",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "§£§â§Ö§Þ§ñ §à§Ò§ß§à§Ó§Ý§Ö§ß§Ú§ñ §ã§ä§â§à§Ü§Ú"
) COMMENT "§­§Ñ§Û§Ü§Ú";

-- §´§Ñ§Ò§Ý§Ú§è§Ñ §ä§Ú§á§à§Ó §à§Ò§ì§Ö§Ü§ä§à§Ó §Ý§Ñ§Û§Ü§à§Ó (§ã§á§â§Ñ§Ó§à§é§ß§Ú§Ü)
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "§ª§Õ§Ö§ß§ä§Ú§æ§Ú§Ü§Ñ§ä§à§â §ã§ä§â§à§Ü§Ú",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "§¯§Ñ§Ù§Ó§Ñ§ß§Ú§Ö §ä§Ú§á§Ñ",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "§£§â§Ö§Þ§ñ §ã§à§Ù§Õ§Ñ§ß§Ú§ñ §ã§ä§â§à§Ü§Ú",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "§£§â§Ö§Þ§ñ §à§Ò§ß§à§Ó§Ý§Ö§ß§Ú§ñ §ã§ä§â§à§Ü§Ú"
) COMMENT "§´§Ú§á§í §à§Ò§ì§Ö§Ü§ä§à§Ó §Ý§Ñ§Û§Ü§à§Ó";

-- §£§ß§Ö§ã§Ö§ß§Ú§Ö §Ù§Ñ§á§Ú§ã§Ö§Û §Ó §ä§Ñ§Ò§Ý§Ú§è§å
INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
  
 -- §³§à§Ù§Õ§Ñ§ß§Ú§Ö §ä§Ñ§Ò§Ý§Ú§è§í §á§à§ã§ä§à§Ó
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- §¤§Ö§ß§Ö§â§Ñ§è§Ú§ñ §Õ§Ñ§ß§ß§í§ç §ß§Ñ §à§ã§ß§à§Ó§Ö §ä§Ñ§Ò§Ý§Ú§è§í messages
INSERT INTO posts (user_id, head, body)
  SELECT user_id, substring(body, 1, locate(' ', body) - 1), body FROM (
    SELECT
      (SELECT id FROM users ORDER BY rand() LIMIT 1) AS user_id,
      (SELECT body FROM messages ORDER BY rand() LIMIT 1) AS body
    FROM messages
  ) p;

 -- §­§Ñ§Û§Ü§Ú §ã§à§à§Ò§ë§Ö§ß§Ú§ñ§Þ
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM messages ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'messages'),
    IF(rand() > 0.5, 0, 1)
  FROM messages -- §Þ§à§Ø§ß§à §å§Ü§Ñ§Ù§Ñ§ä§î §Ý§ð§Ò§å§ð §ä§Ñ§Ò§Ý§Ú§è§å, §ã §Õ§à§ã§ä§Ñ§ä§à§é§ß§í§Þ §Ü§à§Ý§Ú§é§Ö§ã§ä§Ó§à§Þ §Ù§Ñ§á§Ú§ã§Ö§Û
LIMIT 20;

-- §­§Ñ§Û§Ü§Ú §á§à§Ý§î§Ù§à§Ó§Ñ§ä§Ö§Ý§ñ§Þ
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'users'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

-- §­§Ñ§Û§Ü§Ú §Þ§Ö§Õ§Ú§Ñ§æ§Ñ§Û§Ý§Ñ§Þ
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM media ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'media'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

-- §­§Ñ§Û§Ü§Ú §á§à§ã§ä§Ñ§Þ
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM posts ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'posts'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

SELECT * FROM likes;

-- §¥§à§Ò§Ñ§Ó§Ý§ñ§Ö§Þ §Ó§ß§Ö§ê§ß§Ú§Ö §Ü§Ý§ð§é§Ú
ALTER TABLE profiles
  ADD CONSTRAINT profiles_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  ADD CONSTRAINT profiles_fk_gender_id
    FOREIGN KEY (gender_id) REFERENCES gender(id) ON DELETE SET NULL,
  ADD CONSTRAINT profiles_fk_user_status_id
    FOREIGN KEY (user_status_id) REFERENCES user_statuses(id);

ALTER TABLE communities_users
  ADD CONSTRAINT comm_users_fk_comm_id
    FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT comm_users_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
 ;
     
-- §¥§Ý§ñ §ä§Ñ§Ò§Ý§Ú§è§í §ã§à§à§Ò§ë§Ö§ß§Ú§Û
-- §¥§à§Ò§Ñ§Ó§Ý§Ö§ß§Ú§Ö §Ó§ß§Ö§ê§ß§Ú§ç §Ü§Ý§ð§é§Ö§Û
ALTER TABLE messages
  ADD CONSTRAINT messages_fk_from_user_id 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_fk_to_user_id 
    FOREIGN KEY (to_user_id) REFERENCES users(id);
   
   
 ALTER TABLE friendship DROP FOREIGN KEY friendship_fk_friend_id;  
 SELECT * FROM friendship;   

 -- §¥§à§Ò§Ñ§Ó§Ý§Ö§ß§Ú§Ö §Ó§ß§Ö§ê§ß§Ú§ç §Ü§Ý§ð§é§Ö§Û §Õ§Ý§ñ friendship
ALTER TABLE friendship
 ADD CONSTRAINT friendship_fk_user_id
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
 ADD CONSTRAINT friendship_fk_friend_id
 FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE,
 ADD CONSTRAINT friendship_fk_status_id
 FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);

SELECT * FROM profiles;

 -- §¥§à§Ò§Ñ§Ó§Ý§Ö§ß§Ú§Ö §Ó§ß§Ö§ê§ß§Ú§ç §Ü§Ý§ð§é§Ö§Û §Õ§Ý§ñ media
ALTER TABLE media
 ADD CONSTRAINT media_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
 ADD CONSTRAINT media_fk_media_type_id
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);
    
-- §¥§à§Ò§Ñ§Ó§Ý§Ö§ß§Ú§Ö §Ó§ß§Ö§ê§ß§Ú§ç §Ü§Ý§ð§é§Ö§Û §Õ§Ý§ñ posts
ALTER TABLE posts
 ADD CONSTRAINT posts_fk_user_id
  FOREIGN KEY (user_id) REFERENCES users(id),
 ADD CONSTRAINT posts_fk_community_id
  FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE;

-- §¥§à§Ò§Ñ§Ó§Ý§Ö§ß§Ú§Ö §Ó§ß§Ö§ê§ß§Ú§ç §Ü§Ý§ð§é§Ö§Û §Õ§Ý§ñ likes 
ALTER TABLE likes 
 ADD CONSTRAINT likes_fk_user_id
  FOREIGN KEY (user_id) REFERENCES users(id),
 ADD CONSTRAINT likes_fk_target_type_id
  FOREIGN KEY (target_type_id) REFERENCES target_types(id);
 
 -- §¥§à§Ò§Ñ§Ó§Ý§Ö§ß§Ú§Ö §Ó§ß§Ö§ê§ß§Ö§Ô§à §Ü§Ý§ð§é§Ñ photo_id
 ALTER TABLE profiles
  ADD CONSTRAINT profiles_fk_photo_id
    FOREIGN KEY (photo_id) REFERENCES media(id);
   
   
 
 