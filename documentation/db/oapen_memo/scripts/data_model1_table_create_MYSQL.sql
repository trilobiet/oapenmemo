DROP DATABASE IF EXISTS `oapen_memo`;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS oapen_memo.homedir;
DROP TABLE IF EXISTS oapen_memo.query;
DROP TABLE IF EXISTS oapen_memo.script;
DROP TABLE IF EXISTS oapen_memo.task;
DROP TABLE IF EXISTS oapen_memo.runlog;
DROP TABLE IF EXISTS oapen_memo.settings;
SET FOREIGN_KEY_CHECKS = 1;

CREATE DATABASE `oapen_memo` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

CREATE TABLE oapen_memo.homedir (
    id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(45) NOT NULL,
    password VARCHAR(255),
    access_key VARCHAR(32) NOT NULL,
    is_editable BOOLEAN NOT NULL,
    notes TEXT,
    PRIMARY KEY (id),
    UNIQUE (username, access_key)
);

CREATE TABLE oapen_memo.query (
    id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    body TEXT,
    params TEXT,
    notes TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE oapen_memo.script (
    id VARCHAR(36) NOT NULL,
    id_query VARCHAR(36),
    name VARCHAR(255) NOT NULL,
    type ENUM('MAIN','SNIP') NOT NULL,
    body TEXT,
    params TEXT,
    notes TEXT,
    PRIMARY KEY (id),
    UNIQUE (name)
);

CREATE TABLE oapen_memo.task (
    id VARCHAR(36) NOT NULL,
    id_homedir VARCHAR(36) NOT NULL,
    id_script VARCHAR(36),
    file_name VARCHAR(100) NOT NULL,
    extension VARCHAR(32) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    frequency ENUM('D','W','M','Y') NOT NULL,
    is_active BOOLEAN NOT NULL,
    is_public BOOLEAN NOT NULL,
    notes TEXT,
    PRIMARY KEY (id),
    UNIQUE (id_homedir, file_name)
);

CREATE TABLE oapen_memo.runlog (
    id INTEGER AUTO_INCREMENT NOT NULL,
    id_task VARCHAR(36) NOT NULL,
    date DATE NOT NULL,
    is_success BOOLEAN NOT NULL,
    message TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE oapen_memo.setting (
    `key` VARCHAR(32) NOT NULL,
    `value` TEXT NOT NULL,
    PRIMARY KEY (`key`)
);

ALTER TABLE oapen_memo.task ADD FOREIGN KEY (id_homedir) REFERENCES oapen_memo.homedir(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.runlog ADD FOREIGN KEY (id_task) REFERENCES oapen_memo.task(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.task ADD FOREIGN KEY (id_script) REFERENCES oapen_memo.script(id) ON DELETE SET NULL;
ALTER TABLE oapen_memo.script ADD FOREIGN KEY (id_query) REFERENCES oapen_memo.query(id) ON DELETE SET NULL;
