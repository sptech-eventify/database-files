DROP DATABASE IF EXISTS eventitask;

CREATE DATABASE IF NOT EXISTS eventitask;
USE eventitask;

CREATE TABLE usuario (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45),
    email VARCHAR(90),
    password VARCHAR(120),
    img VARCHAR(250)
);

CREATE TABLE board (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45)
);

CREATE TABLE section (
	id INT PRIMARY KEY AUTO_INCREMENT,
    board_id INT,
    name VARCHAR(45),
    color VARCHAR(15),
    FOREIGN KEY (board_id) REFERENCES board(id)
    ON DELETE CASCADE
);

CREATE TABLE task (
	id INT PRIMARY KEY AUTO_INCREMENT,
    section_id INT,
    task_id INT,
	name VARCHAR(45),
    description VARCHAR(250),
    priority INT COMMENT '(0 - desejavel) (1 - importante) (2 - essencia)',
    CONSTRAINT ckPriority CHECK (priority IN (0, 1, 2)),
    fibonacci INT COMMENT '1, 2, 3, 5, 8, 13, 21, 34',
    CONSTRAINT ckFibonacci CHECK (fibonacci IN (1, 2, 3, 5, 8, 13, 21, 34)),
    status INT COMMENT '(0 - pendente) (1 - em desenvolvimento) (2 - concluido)',
    CONSTRAINT ckStatus CHECK (status IN (0, 1, 2)),
    time INT COMMENT 'Em horas',
    data_estimada DATE,
    FOREIGN KEY (section_id) REFERENCES section(id)
    ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES task(id) 
    ON DELETE CASCADE
);

CREATE TABLE user_task (
	user_id INT,
    task_id INT,
    PRIMARY KEY (user_id, task_id),
    FOREIGN KEY (user_id) REFERENCES usuario(id)
    ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES task(id)
    ON DELETE CASCADE
);

CREATE TABLE comment (
	id INT PRIMARY KEY AUTO_INCREMENT,
    task_id INT,
    user_id INT,
    message VARCHAR(350),
    time DATE,
    FOREIGN KEY (task_id) REFERENCES task(id),
    FOREIGN KEY (user_id) REFERENCES usuario(id)
);

CREATE TABLE tag (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(90)
);

CREATE TABLE tag_task (
	tag_id INT,
    task_id INT,
    PRIMARY KEY (tag_id, task_id),
    FOREIGN KEY (tag_id) REFERENCES tag(id)
    ON DELETE CASCADE,
    FOREIGN KEY  (task_id) REFERENCES task(id)
    ON DELETE CASCADE
);