
CREATE DATABASE `oapen_memo` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

CREATE TABLE oapen_memo.homedir (
    id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(45) NOT NULL,
    password VARCHAR(255),
    is_editable boolean NOT NULL,
    notes text,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_memo.homedir
    ADD UNIQUE (username);


CREATE TABLE oapen_memo.query (
    id VARCHAR(36) NOT NULL,
    id_script VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    body text,
    params text,
    notes text,
    PRIMARY KEY (id)
);

CREATE INDEX part_of_id_script ON oapen_memo.query
    (id_script);


CREATE TABLE oapen_memo.script (
    id VARCHAR(36) NOT NULL,
    id_task VARCHAR(36),
    name VARCHAR(255) NOT NULL,
    type ENUM('MAIN','SNIP') NOT NULL,
    body text,
    params text,
    notes text,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_memo.script
    ADD UNIQUE (id_task);



CREATE TABLE oapen_memo.task (
    id VARCHAR(36) NOT NULL,
    id_homedir VARCHAR(36) NOT NULL,
    file_name VARCHAR(100) NOT NULL,
    extension VARCHAR(32) NOT NULL,
    start_date date NOT NULL,
    frequency ENUM('D','W','M','Y') NOT NULL,
    is_active boolean NOT NULL,
    notes text,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_memo.task
    ADD UNIQUE (id_homedir, file_name, extension);



CREATE TABLE oapen_memo.runlog (
    id INTEGER NOT NULL AUTO_INCREMENT,
    id_task VARCHAR(36) NOT NULL,
    date date NOT NULL,
    is_success boolean NOT NULL,
    message text,
    PRIMARY KEY (id)
);

CREATE INDEX part_of_id_task ON oapen_memo.runlog
    (id_task);


CREATE TABLE oapen_memo.settings (
    `key` VARCHAR(32) NOT NULL,
    value text NOT NULL,
    PRIMARY KEY (`key`)
);


ALTER TABLE oapen_memo.query ADD CONSTRAINT FK_query__id_script FOREIGN KEY (id_script) REFERENCES oapen_memo.script(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.script ADD CONSTRAINT FK_script__id_task FOREIGN KEY (id_task) REFERENCES oapen_memo.task(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.task ADD CONSTRAINT FK_task__id_homedir FOREIGN KEY (id_homedir) REFERENCES oapen_memo.homedir(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.runlog ADD CONSTRAINT FK_runlog__id_task FOREIGN KEY (id_task) REFERENCES oapen_memo.task(id) ON DELETE CASCADE;
