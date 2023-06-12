CREATE TABLE oapen_memo_manager.client (
    id VARCHAR(32) NOT NULL,
    fullname VARCHAR(255) NOT NULL,
    username VARCHAR(45) NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_editable BOOLEAN NOT NULL,
    oapen_id VARCHAR(255),
    notes text,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_memo_manager.client
    ADD UNIQUE (username);


CREATE TABLE oapen_memo_manager.query (
    id VARCHAR(32) NOT NULL,
    name VARCHAR(255) NOT NULL,
    body text NOT NULL,
    params text,
    id_script VARCHAR(32) NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX part_of_id_script ON oapen_memo_manager.query
    (id_script);


CREATE TABLE oapen_memo_manager.script (
    id_task VARCHAR(32) NOT NULL,
    name VARCHAR(255) NOT NULL,
    type ENUM('main','sub') NOT NULL,
    body text NOT NULL,
    params text,
    PRIMARY KEY (id_task)
);


# COMMENT ON COLUMN oapen_memo_manager.script.id_task
#    IS 'https://www.baeldung.com/jpa-one-to-one';

CREATE TABLE oapen_memo_manager.task (
    id VARCHAR(32) NOT NULL,
    name VARCHAR(100) NOT NULL,
    start_date date NOT NULL,
    frequency ENUM('D','W','M','Y') NOT NULL,
    id_client VARCHAR(32) NOT NULL,
    is_active BOOLEAN NOT NULL,
    PRIMARY KEY (id)
);

CREATE INDEX part_of_id_client ON oapen_memo_manager.task
    (id_client);


# COMMENT ON COLUMN oapen_memo_manager.task.frequency
#     IS 'D= daily
# W=weekly
# M=monthly
# Y=yearly';

ALTER TABLE oapen_memo_manager.query ADD CONSTRAINT FK_query__id_script FOREIGN KEY (id_script) REFERENCES oapen_memo_manager.script(id_task);
ALTER TABLE oapen_memo_manager.script ADD CONSTRAINT FK_script__id_task FOREIGN KEY (id_task) REFERENCES oapen_memo_manager.task(id);
ALTER TABLE oapen_memo_manager.task ADD CONSTRAINT FK_task__id_client FOREIGN KEY (id_client) REFERENCES oapen_memo_manager.client(id);
