-- ==============================
-- 1. CREATE DATABASE
-- ==============================
CREATE DATABASE multi_user_editor;
USE multi_user_editor;

-- ==============================
-- 2. CREATE TABLES
-- ==============================

CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(50),
    created_at DATETIME
);

CREATE TABLE document (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    created_date DATETIME,
    last_modified DATETIME,
    document_status VARCHAR(50),
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES user(user_id)
);

CREATE TABLE collaboration (
    collaboration_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    document_id INT,
    permission_type VARCHAR(20),
    shared_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (document_id) REFERENCES document(document_id)
);

CREATE TABLE version (
    version_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    modified_by INT,
    modified_date DATETIME,
    content TEXT,
    FOREIGN KEY (document_id) REFERENCES document(document_id),
    FOREIGN KEY (modified_by) REFERENCES user(user_id)
);

CREATE TABLE comment (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    document_id INT,
    comment_text TEXT,
    timestamp DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (document_id) REFERENCES document(document_id)
);

CREATE TABLE activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    document_id INT,
    action_type VARCHAR(50),
    action_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (document_id) REFERENCES document(document_id)
);

CREATE TABLE folder (
    folder_id INT AUTO_INCREMENT PRIMARY KEY,
    folder_name VARCHAR(100),
    created_by INT,
    created_date DATETIME,
    FOREIGN KEY (created_by) REFERENCES user(user_id)
);

CREATE TABLE document_folder (
    id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    folder_id INT,
    FOREIGN KEY (document_id) REFERENCES document(document_id),
    FOREIGN KEY (folder_id) REFERENCES folder(folder_id)
);

-- ==============================
-- 3. INSERT DATA
-- ==============================

INSERT INTO user(name,email,password,role,created_at)
VALUES ('Harsh','harsh@gmail.com','12345','Editor',NOW());

INSERT INTO document(title,created_date,last_modified,document_status,owner_id)
VALUES ('Project Report',NOW(),NOW(),'Active',1);

INSERT INTO collaboration(user_id,document_id,permission_type,shared_date)
VALUES (1,1,'Edit',NOW());

INSERT INTO version(document_id,modified_by,modified_date,content)
VALUES (1,1,NOW(),'Initial Version');

INSERT INTO comment(user_id,document_id,comment_text,timestamp)
VALUES (1,1,'Nice Work',NOW());

INSERT INTO folder(folder_name,created_by,created_date)
VALUES ('Project Files',1,NOW());

INSERT INTO document_folder(document_id,folder_id)
VALUES (1,1);

INSERT INTO activity_log(user_id,document_id,action_type,action_time)
VALUES (1,1,'Edited Document',NOW());

-- ==============================
-- 4. UPDATE DATA
-- ==============================

UPDATE user
SET name='Aryan'
WHERE user_id=1;

UPDATE document
SET title='Updated Report'
WHERE document_id=1;

UPDATE collaboration
SET permission_type='View'
WHERE collaboration_id=1;

-- ==============================
-- 5. DELETE DATA
-- ==============================

DELETE FROM comment
WHERE comment_id=1;

DELETE FROM version
WHERE version_id=1;

-- ==============================
-- 6. SIMPLE SELECT
-- ==============================

SELECT * FROM user;
SELECT * FROM document;
SELECT * FROM collaboration;
SELECT * FROM version;
SELECT * FROM comment;
SELECT * FROM folder;
SELECT * FROM document_folder;
SELECT * FROM activity_log;

-- ==============================
-- 7. JOIN QUERIES (FOR VIVA)
-- ==============================

-- View Documents with Owner Name
SELECT document.title, user.name
FROM document
JOIN user
ON document.owner_id = user.user_id;

-- View Collaboration Details
SELECT user.name, document.title, collaboration.permission_type
FROM collaboration
JOIN user ON collaboration.user_id=user.user_id
JOIN document ON collaboration.document_id=document.document_id;

-- View Comments on Documents
SELECT user.name, document.title, comment.comment_text
FROM comment
JOIN user ON comment.user_id=user.user_id
JOIN document ON comment.document_id=document.document_id;

-- View Document Versions
SELECT document.title, version.content
FROM version
JOIN document ON version.document_id=document.document_id;

-- View Activity Log
SELECT user.name, document.title, activity_log.action_type
FROM activity_log
JOIN user ON activity_log.user_id=user.user_id
JOIN document ON activity_log.document_id=document.document_id;


SELECT * FROM `user` WHERE role = 'Editor';


SELECT * FROM document WHERE document_status = 'Active';


SELECT * FROM collaboration WHERE permission_type = 'Edit';


SELECT * FROM folder WHERE folder_name LIKE 'Project%';


SELECT * FROM `comment` WHERE comment_text LIKE '%Nice%';


SELECT * FROM `user` ORDER BY created_at DESC LIMIT 5;


SELECT * FROM document ORDER BY last_modified DESC LIMIT 3;


SELECT * FROM activity_log ORDER BY action_time DESC LIMIT 10;


SELECT * FROM `version` ORDER BY modified_date DESC LIMIT 5;


SELECT * FROM folder ORDER BY created_date DESC;


SELECT u.name, d.title, d.document_status
FROM `user` u
JOIN document d ON u.user_id = d.owner_id;


SELECT u.name, c.permission_type, d.title
FROM collaboration c
JOIN `user` u ON c.user_id = u.user_id
JOIN document d ON c.document_id = d.document_id;


SELECT d.title, f.folder_name
FROM document d
JOIN document_folder df ON d.document_id = df.document_id
JOIN folder f ON df.folder_id = f.folder_id;


SELECT u.name, v.content
FROM `version` v
JOIN `user` u ON v.modified_by = u.user_id;


SELECT u.name, a.action_type, a.action_time
FROM activity_log a
JOIN `user` u ON a.user_id = u.user_id;


SELECT role, COUNT(*) FROM `user` GROUP BY role;


SELECT document_status, COUNT(*) FROM document GROUP BY document_status;


SELECT user_id, COUNT(*) FROM collaboration GROUP BY user_id;


SELECT document_id, COUNT(*) FROM `comment` GROUP BY document_id;


SELECT user_id, COUNT(*) 
FROM activity_log 
GROUP BY user_id 
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS total_users FROM `user`;


SELECT COUNT(*) AS total_documents FROM document;


SELECT MAX(created_date) FROM document;


SELECT MIN(created_date) FROM document;


SELECT COUNT(*) FROM `version`;


SELECT name FROM `user`
WHERE user_id IN (SELECT owner_id FROM document);


SELECT title FROM document
WHERE owner_id = (SELECT user_id FROM `user` WHERE name='Aryan');


SELECT * FROM document
WHERE document_id IN (
    SELECT document_id FROM collaboration WHERE permission_type='Edit'
);


SELECT * FROM `user`
WHERE user_id = (SELECT MAX(user_id) FROM `user`);


SELECT * FROM `version`
WHERE modified_by = (SELECT user_id FROM `user` WHERE name='Aryan');

 (Most active user)
SELECT user_id, COUNT(*) AS activity_count
FROM activity_log
GROUP BY user_id
ORDER BY activity_count DESC
LIMIT 1;

 (Documents with most comments)
SELECT document_id, COUNT(*) AS comment_count
FROM `comment`
GROUP BY document_id
ORDER BY comment_count DESC
LIMIT 1;
