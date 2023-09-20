DROP DATABASE IF EXISTS eventitask;

CREATE DATABASE IF NOT EXISTS eventitask;

CREATE TABLE eventitask.user (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45),
    email VARCHAR(90),
    password VARCHAR(120),
    img VARCHAR(250),
    date_creation DATETIME
);
CREATE INDEX idx_user_id ON eventitask.user (id);

CREATE TABLE eventitask.board (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45),
    date_creation DATETIME,
    created_by INT,
	FOREIGN KEY (created_by) REFERENCES user (id)  
);
CREATE INDEX idx_board_id ON eventitask.board (id);

CREATE TABLE eventitask.section (
	id INT PRIMARY KEY AUTO_INCREMENT,
    board_id INT,
    name VARCHAR(45),
    color VARCHAR(15),
    date_creation DATETIME,
    created_by INT,
    FOREIGN KEY (board_id) REFERENCES board(id)
    ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES user (id)
);
CREATE INDEX idx_section_id ON eventitask.section (id);

CREATE TABLE eventitask.task (
	id INT PRIMARY KEY AUTO_INCREMENT,
    section_id INT,
    task_id INT,
	name VARCHAR(128),
    description VARCHAR(512),
    priority INT COMMENT '(0 - desejavel) (1 - importante) (2 - essencial)',
    CONSTRAINT ckPriority CHECK (priority IN (0, 1, 2)),
    fibonacci INT COMMENT '1, 2, 3, 5, 8, 13, 21, 34',
    CONSTRAINT ckFibonacci CHECK (fibonacci IN (1, 2, 3, 5, 8, 13, 21, 34)),
    status INT COMMENT '(0 - pendente) (1 - em desenvolvimento) (2 - concluido)',
    CONSTRAINT ckStatus CHECK (status IN (0, 1, 2)),
    time INT COMMENT 'Em horas',
    data_estimada DATE,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES user(id),
    date_creation DATETIME,
    FOREIGN KEY (section_id) REFERENCES section(id)
    ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES task(id) 
    ON DELETE CASCADE
);
CREATE INDEX idx_task_id ON eventitask.task (id);

CREATE TABLE eventitask.user_task (
	user_id INT,
    task_id INT,
    PRIMARY KEY (user_id, task_id),
    FOREIGN KEY (user_id) REFERENCES user (id)
    ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES task(id)
    ON DELETE CASCADE,
    date_creation DATETIME,
    alocated_by INT,
    FOREIGN KEY (alocated_by) REFERENCES user (id)
);

CREATE TABLE eventitask.comment (
	id INT PRIMARY KEY AUTO_INCREMENT,
    task_id INT,
    user_id INT,
    message VARCHAR(350),
    time DATE,
	date_creation DATETIME,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES user (id),
    FOREIGN KEY (task_id) REFERENCES task (id),
    FOREIGN KEY (user_id) REFERENCES user (id)
);
CREATE INDEX idx_comment_id ON eventitask.comment (id);

CREATE TABLE eventitask.tag (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(90),
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES user (id),
    date_creation DATETIME
);
CREATE INDEX idx_tag_id ON eventitask.tag (id);

CREATE TABLE eventitask.tag_task (
	tag_id INT,
    task_id INT,
    PRIMARY KEY (tag_id, task_id),
    FOREIGN KEY (tag_id) REFERENCES tag(id)
    ON DELETE CASCADE,
    FOREIGN KEY  (task_id) REFERENCES task(id)
    ON DELETE CASCADE,
    date_creation DATETIME,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES user (id)
);

CREATE TABLE eventitask.audit (
	id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(32),
    column_name VARCHAR(32),
    type_change VARCHAR(32),
    old_value VARCHAR(128),
    new_value VARCHAR(128),
	change_time DATETIME,
	changed_by INT,
    FOREIGN KEY (changed_by) REFERENCES user (id)
);
CREATE INDEX idx_audit_id ON eventitask.audit (id);