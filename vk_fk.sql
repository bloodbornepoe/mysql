USE vk;

SHOW TABLES;

-- ����٧էѧߧڧ� ��ѧҧݧڧ�� �ݧѧۧܧ��
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "���է֧ߧ�ڧ�ڧܧѧ��� �����ܧ�",
  user_id INT UNSIGNED NOT NULL COMMENT "���է֧ߧ�ڧ�ڧܧѧ��� ���ݧ�٧�ӧѧ�֧ݧ�",
  target_id INT UNSIGNED NOT NULL COMMENT "���է֧ߧ�ڧ�ڧܧѧ��� ��ҧ�֧ܧ��",
  target_type_id INT UNSIGNED NOT NULL COMMENT "���է֧ߧ�ڧ�ڧܧѧ��� ��ڧ�� ��ҧ�֧ܧ��",
  like_type TINYINT UNSIGNED NOT NULL COMMENT "���է֧ߧ�ڧ�ڧܧѧ��� ��ڧ�� �ݧѧۧܧ� (1 - �ݧѧۧ�, 0 - �էڧ٧ݧѧۧ�)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����֧ާ� ���٧էѧߧڧ� �����ܧ�",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����֧ާ� ��ҧߧ�ӧݧ֧ߧڧ� �����ܧ�"
) COMMENT "���ѧۧܧ�";

-- ���ѧҧݧڧ�� ��ڧ��� ��ҧ�֧ܧ��� �ݧѧۧܧ�� (����ѧӧ��ߧڧ�)
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "���է֧ߧ�ڧ�ڧܧѧ��� �����ܧ�",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "���ѧ٧ӧѧߧڧ� ��ڧ��",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����֧ާ� ���٧էѧߧڧ� �����ܧ�",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����֧ާ� ��ҧߧ�ӧݧ֧ߧڧ� �����ܧ�"
) COMMENT "���ڧ�� ��ҧ�֧ܧ��� �ݧѧۧܧ��";

-- ���ߧ֧�֧ߧڧ� �٧ѧ�ڧ�֧� �� ��ѧҧݧڧ��
INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
  
 -- ����٧էѧߧڧ� ��ѧҧݧڧ�� �������
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

-- ���֧ߧ֧�ѧ�ڧ� �էѧߧߧ�� �ߧ� ���ߧ�ӧ� ��ѧҧݧڧ�� messages
INSERT INTO posts (user_id, head, body)
  SELECT user_id, substring(body, 1, locate(' ', body) - 1), body FROM (
    SELECT
      (SELECT id FROM users ORDER BY rand() LIMIT 1) AS user_id,
      (SELECT body FROM messages ORDER BY rand() LIMIT 1) AS body
    FROM messages
  ) p;

 -- ���ѧۧܧ� ����ҧ�֧ߧڧ��
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM messages ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'messages'),
    IF(rand() > 0.5, 0, 1)
  FROM messages -- �ާ�اߧ� ��ܧѧ٧ѧ�� �ݧ�ҧ�� ��ѧҧݧڧ��, �� �է���ѧ���ߧ�� �ܧ�ݧڧ�֧��ӧ�� �٧ѧ�ڧ�֧�
LIMIT 20;

-- ���ѧۧܧ� ���ݧ�٧�ӧѧ�֧ݧ��
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'users'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

-- ���ѧۧܧ� �ާ֧էڧѧ�ѧۧݧѧ�
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM media ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'media'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

-- ���ѧۧܧ� �����ѧ�
INSERT INTO likes (user_id, target_id, target_type_id, like_type) 
  SELECT
    (SELECT id FROM users ORDER BY rand() LIMIT 1),
    (SELECT id FROM posts ORDER BY rand() LIMIT 1),
    (SELECT id FROM target_types WHERE name = 'posts'),
    IF(rand() > 0.5, 0, 1)
  FROM messages
LIMIT 20;

SELECT * FROM likes;

-- ����ҧѧӧݧ�֧� �ӧߧ֧�ߧڧ� �ܧݧ���
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
     
-- ���ݧ� ��ѧҧݧڧ�� ����ҧ�֧ߧڧ�
-- ����ҧѧӧݧ֧ߧڧ� �ӧߧ֧�ߧڧ� �ܧݧ��֧�
ALTER TABLE messages
  ADD CONSTRAINT messages_fk_from_user_id 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_fk_to_user_id 
    FOREIGN KEY (to_user_id) REFERENCES users(id);
   
   
 ALTER TABLE friendship DROP FOREIGN KEY friendship_fk_friend_id;  
 SELECT * FROM friendship;   

 -- ����ҧѧӧݧ֧ߧڧ� �ӧߧ֧�ߧڧ� �ܧݧ��֧� �էݧ� friendship
ALTER TABLE friendship
 ADD CONSTRAINT friendship_fk_user_id
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
 ADD CONSTRAINT friendship_fk_friend_id
 FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE,
 ADD CONSTRAINT friendship_fk_status_id
 FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);

SELECT * FROM profiles;

 -- ����ҧѧӧݧ֧ߧڧ� �ӧߧ֧�ߧڧ� �ܧݧ��֧� �էݧ� media
ALTER TABLE media
 ADD CONSTRAINT media_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
 ADD CONSTRAINT media_fk_media_type_id
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);
    
-- ����ҧѧӧݧ֧ߧڧ� �ӧߧ֧�ߧڧ� �ܧݧ��֧� �էݧ� posts
ALTER TABLE posts
 ADD CONSTRAINT posts_fk_user_id
  FOREIGN KEY (user_id) REFERENCES users(id),
 ADD CONSTRAINT posts_fk_community_id
  FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE;

-- ����ҧѧӧݧ֧ߧڧ� �ӧߧ֧�ߧڧ� �ܧݧ��֧� �էݧ� likes 
ALTER TABLE likes 
 ADD CONSTRAINT likes_fk_user_id
  FOREIGN KEY (user_id) REFERENCES users(id),
 ADD CONSTRAINT likes_fk_target_type_id
  FOREIGN KEY (target_type_id) REFERENCES target_types(id);
 
 -- ����ҧѧӧݧ֧ߧڧ� �ӧߧ֧�ߧ֧ԧ� �ܧݧ��� photo_id
 ALTER TABLE profiles
  ADD CONSTRAINT profiles_fk_photo_id
    FOREIGN KEY (photo_id) REFERENCES media(id);
   
   
 
 