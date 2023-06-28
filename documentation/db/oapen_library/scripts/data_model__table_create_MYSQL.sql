
CREATE DATABASE `oapen_library` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;


CREATE TABLE oapen_library.title (
    handle VARCHAR(25) NOT NULL,
    sysid VARCHAR(36),
    handle_publisher VARCHAR(25),
    part_of_book VARCHAR(36),
    type VARCHAR(10),
    year_available INTEGER,
    download_url text,
    thumbnail text,
    license text,
    webshop_url text,
    description_abstract text,
    is_part_of_series text,
    title text,
    title_alternative text,
    terms_abstract text,
    abstract_other_language text,
    description_other_language text,
    chapter_number text,
    imprint text,
    pages text,
    place_publication text,
    series_number text,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (handle)
);

CREATE INDEX part_of_handle_publisher ON oapen_library.title
    (handle_publisher);



CREATE TABLE oapen_library.language (
    language VARCHAR(25) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (language, handle_title)
);


CREATE TABLE oapen_library.export_chunk (
    type VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    content mediumtext NULL,
    url text NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (type, handle_title)
);


CREATE TABLE oapen_library.contribution (
    role VARCHAR(10) NOT NULL,
    name_contributor VARCHAR(255) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (role, name_contributor, handle_title)
);


CREATE TABLE oapen_library.identifier (
    identifier VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    identifier_type VARCHAR(10) NOT NULL,
    PRIMARY KEY (identifier)
);

CREATE INDEX part_of_handle_title ON oapen_library.identifier
    (handle_title);

CREATE TABLE oapen_library.classification (
    code VARCHAR(10) NOT NULL,
    description text NOT NULL,
    PRIMARY KEY (code)
);


CREATE TABLE oapen_library.subject_other (
    subject VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (subject, handle_title)
);


CREATE TABLE oapen_library.subject_classification (
    code_classification VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (code_classification, handle_title)
);


CREATE TABLE oapen_library.funder (
    handle VARCHAR(25) NOT NULL,
    name text NOT NULL,
    acronyms text,
    number text,
    PRIMARY KEY (handle)
);


CREATE TABLE oapen_library.funding (
    handle_title VARCHAR(25) NOT NULL,
    handle_funder VARCHAR(25) NOT NULL,
    PRIMARY KEY (handle_title, handle_funder)
);


CREATE TABLE oapen_library.publisher (
    handle VARCHAR(25) NOT NULL,
    name text NOT NULL,
    website text,
    PRIMARY KEY (handle)
);


CREATE TABLE oapen_library.contributor (
    name VARCHAR(255) NOT NULL,
    orcid char(19),
    PRIMARY KEY (name)
);

ALTER TABLE oapen_library.contributor
    ADD UNIQUE (orcid);


CREATE TABLE oapen_library.institution (
    id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    alt_names text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_library.institution
    ADD UNIQUE (name);


CREATE TABLE oapen_library.affiliation (
    id INTEGER NOT NULL,
    id_institution INTEGER NOT NULL,
    orcid char(19) NOT NULL,
    from_date date NOT NULL,
    until_date date NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE oapen_library.affiliation
    ADD UNIQUE (id_institution, orcid, from_date, until_date);


CREATE TABLE oapen_library.grant_data (
    property VARCHAR(10) NOT NULL,
    value VARCHAR(255) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (property, value, handle_title)
);


CREATE TABLE oapen_library.collection (
    collection VARCHAR(255) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (collection, handle_title)
);

ALTER TABLE oapen_library.title ADD CONSTRAINT FK_title__handle_publisher FOREIGN KEY (handle_publisher) REFERENCES oapen_library.publisher(handle);
ALTER TABLE oapen_library.language ADD CONSTRAINT FK_language__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.export_chunk ADD CONSTRAINT FK_export_chunk__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.contribution ADD CONSTRAINT FK_contribution__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.contribution ADD CONSTRAINT FK_contribution__name_contributor FOREIGN KEY (name_contributor) REFERENCES oapen_library.contributor(name);
ALTER TABLE oapen_library.identifier ADD CONSTRAINT FK_identifier__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.subject_other ADD CONSTRAINT FK_subject_other__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.subject_classification ADD CONSTRAINT FK_subject_classification__code_classification FOREIGN KEY (code_classification) REFERENCES oapen_library.classification(code);
ALTER TABLE oapen_library.subject_classification ADD CONSTRAINT FK_subject_classification__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.funding ADD CONSTRAINT FK_funding__handle_funder FOREIGN KEY (handle_funder) REFERENCES oapen_library.funder(handle) ON DELETE RESTRICT;
ALTER TABLE oapen_library.funding ADD CONSTRAINT FK_funding__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.affiliation ADD CONSTRAINT FK_affiliation__orcid FOREIGN KEY (orcid) REFERENCES oapen_library.contributor(orcid);
ALTER TABLE oapen_library.affiliation ADD CONSTRAINT FK_affiliation__id_institution FOREIGN KEY (id_institution) REFERENCES oapen_library.institution(id);
ALTER TABLE oapen_library.grant_data ADD CONSTRAINT FK_grant_data__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
ALTER TABLE oapen_library.collection ADD CONSTRAINT FK_collection__handle_title FOREIGN KEY (handle_title) REFERENCES oapen_library.title(handle) ON DELETE CASCADE;
