CREATE TABLE oapen_memo.title (
    id VARCHAR(36) NOT NULL,
    handle VARCHAR(25) NOT NULL,
    collection_no VARCHAR(25),
    download_url VARCHAR(255),
    thumbnail VARCHAR(100),
    license VARCHAR(255),
    webshop_url VARCHAR(255),
    dc_date_available DATETIME NOT NULL,
    dc_date_issued date,
    dc_description text,
    dc_description_abstract text,
    dc_description_provenance text,
    dc_identifier_issn VARCHAR(255),
    dc_relation_ispartofseries VARCHAR(100),
    dc_title VARCHAR(100) NOT NULL,
    dc_title_alternative VARCHAR(100),
    dc_type VARCHAR(10) NOT NULL,
    dc_terms_abstract text,
    oapen_abstractotherlanguage text,
    oapen_chapternumber VARCHAR(4),
    oapen_description_otherlanguage text,
    oapen_embargo VARCHAR(255),
    oapen_identifier VARCHAR(255),
    oapen_identifier_doi VARCHAR(255),
    oapen_identifier_ocn VARCHAR(15),
    oapen_imprint VARCHAR(100),
    oapen_pages VARCHAR(10),
    oapen_placepublication VARCHAR(100),
    oapen_relation_partofbook VARCHAR(36) NOT NULL,
    oapen_relation_ispublishedby VARCHAR(25),
    oapen_seriesnumber VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE INDEX part_of_oapen_relation_partofbook ON oapen_memo.title
    (oapen_relation_partofbook);
CREATE INDEX part_of_oapen_relation_ispublishedby ON oapen_memo.title
    (oapen_relation_ispublishedby);

CREATE TABLE oapen_memo.dc_language (
    language VARCHAR(10) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (language, id_title)
);


CREATE TABLE oapen_memo.export_chunk (
    type VARCHAR(10) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    content text NOT NULL,
    PRIMARY KEY (type, id_title)
);


CREATE TABLE oapen_memo.dc_date_accessioned (
    date DATETIME NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (date, id_title)
);


CREATE TABLE oapen_memo.identifier_isbn (
    isbn VARCHAR(15) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (isbn)
);

CREATE INDEX part_of_id_title ON oapen_memo.identifier_isbn
    (id_title);


CREATE TABLE oapen_memo.dc_contributor_role (
    name VARCHAR(100) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    type VARCHAR(10) NOT NULL,
    id_institution VARCHAR(36)
);

CREATE INDEX part_of_name ON oapen_memo.dc_contributor_role
    (name);
CREATE INDEX part_of_id_title ON oapen_memo.dc_contributor_role
    (id_title);


CREATE TABLE oapen_memo.dc_identifier (
    identifier VARCHAR(50) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (identifier)
);

CREATE INDEX part_of_id_title ON oapen_memo.dc_identifier
    (id_title);


CREATE TABLE oapen_memo.classification (
    id VARCHAR(7) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE oapen_memo.dc_subject_other (
    subject VARCHAR(100) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (subject)
);

CREATE INDEX part_of_id_title ON oapen_memo.dc_subject_other
    (id_title);


CREATE TABLE oapen_memo.dc_subject_classification (
    id_classification VARCHAR(5) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (id_classification, id_title)
);


CREATE TABLE oapen_memo.funder (
    id VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE oapen_memo.oapen_relation_isfundedby (
    grant_number VARCHAR(100) NOT NULL,
    grant_program VARCHAR(255),
    grant_project VARCHAR(255),
    grant_acronym VARCHAR(100),
    id_funder VARCHAR(25) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (grant_number)
);

CREATE INDEX part_of_id_funder ON oapen_memo.oapen_relation_isfundedby
    (id_funder);
CREATE INDEX part_of_id_title ON oapen_memo.oapen_relation_isfundedby
    (id_title);


CREATE TABLE oapen_memo.funder_name (
    name VARCHAR(255) NOT NULL,
    id_funder VARCHAR(25) NOT NULL,
    PRIMARY KEY (name)
);

CREATE INDEX part_of_id_funder ON oapen_memo.funder_name
    (id_funder);


CREATE TABLE oapen_memo.publisher (
    id VARCHAR(25) NOT NULL,
    name VARCHAR(100) NOT NULL,
    website VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE TABLE oapen_memo.contributor (
    name VARCHAR(100) NOT NULL,
    orcid char(19) NOT NULL,
    PRIMARY KEY (name)
);


CREATE TABLE oapen_memo.institution (
    id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);


ALTER TABLE oapen_memo.title ADD CONSTRAINT FK_title__oapen_relation_partofbook FOREIGN KEY (oapen_relation_partofbook) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.title ADD CONSTRAINT FK_title__oapen_relation_ispublishedby FOREIGN KEY (oapen_relation_ispublishedby) REFERENCES oapen_memo.publisher(id);
ALTER TABLE oapen_memo.dc_language ADD CONSTRAINT FK_dc_language__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.export_chunk ADD CONSTRAINT FK_export_chunk__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.dc_date_accessioned ADD CONSTRAINT FK_dc_date_accessioned__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.identifier_isbn ADD CONSTRAINT FK_identifier_isbn__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.dc_contributor_role ADD CONSTRAINT FK_dc_contributor_role__name FOREIGN KEY (name) REFERENCES oapen_memo.contributor(name);
ALTER TABLE oapen_memo.dc_contributor_role ADD CONSTRAINT FK_dc_contributor_role__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.dc_contributor_role ADD CONSTRAINT FK_dc_contributor_role__id_institution FOREIGN KEY (id_institution) REFERENCES oapen_memo.institution(id);
ALTER TABLE oapen_memo.dc_identifier ADD CONSTRAINT FK_dc_identifier__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.dc_subject_other ADD CONSTRAINT FK_dc_subject_other__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.dc_subject_classification ADD CONSTRAINT FK_dc_subject_classification__id_classification FOREIGN KEY (id_classification) REFERENCES oapen_memo.classification(id);
ALTER TABLE oapen_memo.dc_subject_classification ADD CONSTRAINT FK_dc_subject_classification__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.oapen_relation_isfundedby ADD CONSTRAINT FK_oapen_relation_isfundedby__id_funder FOREIGN KEY (id_funder) REFERENCES oapen_memo.funder(id);
ALTER TABLE oapen_memo.oapen_relation_isfundedby ADD CONSTRAINT FK_oapen_relation_isfundedby__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id);
ALTER TABLE oapen_memo.funder_name ADD CONSTRAINT FK_funder_name__id_funder FOREIGN KEY (id_funder) REFERENCES oapen_memo.funder(id);
