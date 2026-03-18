CREATE DATABASE IF NOT EXISTS login_app;

USE login_app;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL
);

INSERT INTO users (username, password)
VALUES ('admin', 'admin123');

INSERT INTO users (username, password)
VALUES ("test", 'test');

 SELECT * FROM users;