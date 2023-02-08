CREATE TABLE oapen_memo.title (
    id VARCHAR(36) NOT NULL,
    handle VARCHAR(25) NOT NULL,
    collection VARCHAR(25),
    download_url VARCHAR(255),
    thumbnail VARCHAR(100),
    license VARCHAR(255),
    webshop_url VARCHAR(255),
    date_available DATETIME,
    date_issued date,
    description text,
    description_abstract text,
    description_provenance text,
    is_part_of_series VARCHAR(100),
    title VARCHAR(100),
    title_alternative VARCHAR(100),
    type VARCHAR(10),
    terms_abstract text,
    abstract_other_language text,
    description_other_language text,
    chapter_number VARCHAR(25),
    embargo VARCHAR(255),
    oapen_identifier VARCHAR(255),
    imprint VARCHAR(100),
    pages VARCHAR(10),
    place_publication VARCHAR(100),
    is_published_by VARCHAR(25),
    series_number VARCHAR(100),
    part_of_book VARCHAR(36),
    PRIMARY KEY (id)
);

CREATE INDEX part_of_is_published_by ON oapen_memo.title
    (is_published_by);


CREATE TABLE oapen_memo.language (
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


CREATE TABLE oapen_memo.date_accessioned (
    date DATETIME NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (date, id_title)
);


CREATE TABLE oapen_memo.contributor_role (
    name_contributor VARCHAR(100) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    type VARCHAR(10),
    id_institution VARCHAR(36),
    PRIMARY KEY (name_contributor, id_title)
);

CREATE INDEX part_of_id_institution ON oapen_memo.contributor_role
    (id_institution);


CREATE TABLE oapen_memo.identifier (
    identifier VARCHAR(100) NOT NULL,
    identifier_type VARCHAR(10) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (identifier)
);

CREATE INDEX part_of_id_title ON oapen_memo.identifier
    (id_title);


CREATE TABLE oapen_memo.classification (
    code VARCHAR(7) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (code)
);


CREATE TABLE oapen_memo.subject_other (
    subject VARCHAR(100) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (subject)
);

CREATE INDEX part_of_id_title ON oapen_memo.subject_other
    (id_title);


CREATE TABLE oapen_memo.subject_classification (
    code_classification VARCHAR(5) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (code_classification, id_title)
);


CREATE TABLE oapen_memo.funder (
    handle VARCHAR(25) NOT NULL,
    name VARCHAR(255) NOT NULL,
    acronyms text NOT NULL,
    PRIMARY KEY (handle)
);


CREATE TABLE oapen_memo.funding (
    grant_number VARCHAR(100),
    grant_program VARCHAR(255),
    grant_project VARCHAR(255),
    grant_acronym VARCHAR(100),
    handle_funder VARCHAR(25) NOT NULL,
    id_title VARCHAR(36) NOT NULL,
    PRIMARY KEY (handle_funder, id_title)
);


CREATE TABLE oapen_memo.publisher (
    id VARCHAR(25) NOT NULL,
    name VARCHAR(100) NOT NULL,
    website VARCHAR(100),
    PRIMARY KEY (id)
);


CREATE TABLE oapen_memo.contributor (
    name VARCHAR(100) NOT NULL,
    orcid char(19),
    PRIMARY KEY (name)
);


CREATE TABLE oapen_memo.institution (
    id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);


ALTER TABLE oapen_memo.title ADD CONSTRAINT FK_title__is_published_by FOREIGN KEY (is_published_by) REFERENCES oapen_memo.publisher(id);
ALTER TABLE oapen_memo.language ADD CONSTRAINT FK_language__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.export_chunk ADD CONSTRAINT FK_export_chunk__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.date_accessioned ADD CONSTRAINT FK_date_accessioned__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.contributor_role ADD CONSTRAINT FK_contributor_role__name_contributor FOREIGN KEY (name_contributor) REFERENCES oapen_memo.contributor(name) ON DELETE RESTRICT;
ALTER TABLE oapen_memo.contributor_role ADD CONSTRAINT FK_contributor_role__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.contributor_role ADD CONSTRAINT FK_contributor_role__id_institution FOREIGN KEY (id_institution) REFERENCES oapen_memo.institution(id) ON DELETE RESTRICT;
ALTER TABLE oapen_memo.identifier ADD CONSTRAINT FK_identifier__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.subject_other ADD CONSTRAINT FK_subject_other__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.subject_classification ADD CONSTRAINT FK_subject_classification__code_classification FOREIGN KEY (code_classification) REFERENCES oapen_memo.classification(code) ON DELETE RESTRICT;
ALTER TABLE oapen_memo.subject_classification ADD CONSTRAINT FK_subject_classification__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
ALTER TABLE oapen_memo.funding ADD CONSTRAINT FK_funding__handle_funder FOREIGN KEY (handle_funder) REFERENCES oapen_memo.funder(handle) ON DELETE RESTRICT;
ALTER TABLE oapen_memo.funding ADD CONSTRAINT FK_funding__id_title FOREIGN KEY (id_title) REFERENCES oapen_memo.title(id) ON DELETE CASCADE;
