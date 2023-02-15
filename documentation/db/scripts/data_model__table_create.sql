CREATE TABLE oapen_memo.title (
    handle VARCHAR(25) NOT NULL,
    sysid VARCHAR(36) NOT NULL,
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
    title VARCHAR(255),
    title_alternative VARCHAR(255),
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
    handle_publisher VARCHAR(25),
    series_number VARCHAR(100),
    part_of_book VARCHAR(36),
    PRIMARY KEY (handle)
);

CREATE INDEX part_of_handle_publisher ON oapen_memo.title
    (handle_publisher);


CREATE TABLE oapen_memo.language (
    language VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (language, handle_title)
);


CREATE TABLE oapen_memo.export_chunk (
    content text NOT NULL,
    type VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (type, handle_title)
);


CREATE TABLE oapen_memo.date_accessioned (
    date DATETIME NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (date, handle_title)
);


CREATE TABLE oapen_memo.contribution (
    role VARCHAR(10) NOT NULL,
    name_contributor VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (role, name_contributor, handle_title)
);


CREATE TABLE oapen_memo.identifier (
    identifier VARCHAR(100) NOT NULL,
    identifier_type VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (identifier)
);

CREATE INDEX part_of_handle_title ON oapen_memo.identifier
    (handle_title);


CREATE TABLE oapen_memo.classification (
    code VARCHAR(7) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (code)
);


CREATE TABLE oapen_memo.subject_other (
    subject VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (subject, handle_title)
);


CREATE TABLE oapen_memo.subject_classification (
    code_classification VARCHAR(5) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (code_classification, handle_title)
);


CREATE TABLE oapen_memo.funder (
    handle VARCHAR(25) NOT NULL,
    name VARCHAR(255) NOT NULL,
    acronyms text,
    PRIMARY KEY (handle)
);


CREATE TABLE oapen_memo.funding (
    grant_number VARCHAR(100),
    grant_program VARCHAR(255),
    grant_project VARCHAR(255),
    grant_acronym VARCHAR(100),
    handle_title VARCHAR(25) NOT NULL,
    handle_funder VARCHAR(25) NOT NULL,
    PRIMARY KEY (handle_title, handle_funder)
);


CREATE TABLE oapen_memo.publisher (
    handle VARCHAR(25) NOT NULL,
    name VARCHAR(100) NOT NULL,
    website VARCHAR(100),
    PRIMARY KEY (handle)
);


CREATE TABLE oapen_memo.contributor (
    name VARCHAR(100) NOT NULL,
    orcid char(19),
    PRIMARY KEY (name)
);

CREATE INDEX part_of_orcid ON oapen_memo.contributor
    (orcid);


CREATE TABLE oapen_memo.institution (
    id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    alt_names text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_memo.institution
    ADD UNIQUE (name);


CREATE TABLE oapen_memo.affiliation (
    id INTEGER NOT NULL,
    id_institution INTEGER NOT NULL,
    orcid char(19) NOT NULL,
    from_date date NOT NULL,
    until_date date NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_memo.affiliation
    ADD UNIQUE (id_institution, orcid, from_date, until_date);

    
ALTER TABLE oapen_memo.title ADD CONSTRAINT FK_title__handle_publisher FOREIGN KEY (handle_publisher) REFERENCES oapen_memo.publisher(handle);
ALTER TABLE oapen_memo.language ADD CONSTRAINT FK_language__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_memo.export_chunk ADD CONSTRAINT FK_export_chunk__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_memo.date_accessioned ADD CONSTRAINT FK_date_accessioned__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_memo.contribution ADD CONSTRAINT FK_contribution__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle);
ALTER TABLE oapen_memo.contribution ADD CONSTRAINT FK_contribution__name_contributor FOREIGN KEY (name_contributor) REFERENCES oapen_memo.contributor(name);
ALTER TABLE oapen_memo.identifier ADD CONSTRAINT FK_identifier__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_memo.subject_other ADD CONSTRAINT FK_subject_other__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_memo.subject_classification ADD CONSTRAINT FK_subject_classification__code_classification FOREIGN KEY (code_classification) REFERENCES oapen_memo.classification(code);
ALTER TABLE oapen_memo.subject_classification ADD CONSTRAINT FK_subject_classification__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_memo.funding ADD CONSTRAINT FK_funding__handle_funder FOREIGN KEY (handle_funder) REFERENCES oapen_memo.funder(handle) ON DELETE RESTRICT;
ALTER TABLE oapen_memo.funding ADD CONSTRAINT FK_funding__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_memo.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_memo.affiliation ADD CONSTRAINT FK_affiliation__orcid FOREIGN KEY (orcid) REFERENCES oapen_memo.contributor(orcid);
ALTER TABLE oapen_memo.affiliation ADD CONSTRAINT FK_affiliation__id_institution FOREIGN KEY (id_institution) REFERENCES oapen_memo.institution(id);
