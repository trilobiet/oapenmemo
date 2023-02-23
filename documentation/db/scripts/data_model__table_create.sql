CREATE TABLE public.title (
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

CREATE INDEX part_of_handle_publisher ON public.title
    (handle_publisher);


COMMENT ON COLUMN public.title.handle
    IS 'Handle (without url part), e.g. 20.500.12657/53113';
COMMENT ON COLUMN public.title.sysid
    IS 'UUID as used in DSpace. Field part_of_book refers to this value.';
COMMENT ON COLUMN public.title.collection
    IS 'e.g. 20.500.12657/8 
TODO: where can this be found in the API?';
COMMENT ON COLUMN public.title.download_url
    IS 'E.g. /rest/bitstreams/ea7d1f20-5fa6-4d43-8307-22f9b40e2fbb/retrieve';
COMMENT ON COLUMN public.title.thumbnail
    IS 'e.g. m.celama-eb.5.120678.cover.jpg

Json path: 
(List) $.[{row}].bitstreams[?(@.bundleName == ''THUMBNAIL'')].name
';
COMMENT ON COLUMN public.title.date_issued
    IS 'Most of the time only a year, sometimes a full date.';
COMMENT ON COLUMN public.title.type
    IS 'book OR chapter';
COMMENT ON COLUMN public.title.oapen_identifier
    IS 'A url. Very seldom multiple values. Since it is not likely to be part of complex queries, join the values together in a pipe separated field and search using ''LIKE''.
 
E.g. 
https://openresearchlibrary.org/viewer/61ee7f71-18ae-4308-b882-78945f0e7492
';
COMMENT ON COLUMN public.title.handle_publisher
    IS 'Json Path:

(Object) $.[row].metadata[?(@.key == ''oapen.relation.isPublishedBy'')]

(Object) $.[0].metadata[?(@.key == ''publisher.name'')]';

CREATE TABLE public.language (
    language VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (language, handle_title)
);


CREATE TABLE public.export_chunk (
    content text NOT NULL,
    type VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (type, handle_title)
);


CREATE TABLE public.date_accessioned (
    date DATETIME NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (date, handle_title)
);


CREATE TABLE public.contribution (
    role VARCHAR(10) NOT NULL,
    name_contributor VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (role, name_contributor, handle_title)
);


COMMENT ON COLUMN public.contribution.role
    IS 'Advisor || Author || Editor || Other';

CREATE TABLE public.identifier (
    identifier VARCHAR(100) NOT NULL,
    identifier_type VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (identifier)
);

CREATE INDEX part_of_handle_title ON public.identifier
    (handle_title);


COMMENT ON TABLE public.identifier
    IS 'All sorts of identifiers for a title (ISBN, ISSN, OCN, DOI).';
COMMENT ON COLUMN public.identifier.identifier_type
    IS 'ISBN, ISSN, OCN, DOI';

CREATE TABLE public.classification (
    code VARCHAR(7) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (code)
);


COMMENT ON COLUMN public.classification.description
    IS 'Each classification consists of a code like ''AVGC6'' (or shorter) that will serve as id field.

Values are available in dc.subject.classification fields that must be split by ''::''. The ''bic Book Industry'' string must be removed.

bic Book Industry Communication::K Economics, finance, business & management::KN Industry & industrial studies::KND Manufacturing industries::KNDF Food manufacturing & related industries


';

CREATE TABLE public.subject_other (
    subject VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (subject, handle_title)
);


CREATE TABLE public.subject_classification (
    code_classification VARCHAR(5) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (code_classification, handle_title)
);


CREATE TABLE public.funder (
    handle VARCHAR(25) NOT NULL,
    name VARCHAR(255) NOT NULL,
    acronyms text,
    number VARCHAR(100) NOT NULL,
    PRIMARY KEY (handle)
);


COMMENT ON COLUMN public.funder.handle
    IS 'A handle, e.g. 20.500.12657/14222
(https://library.oapen.org/handle/20.500.12657/14222)';
COMMENT ON COLUMN public.funder.name
    IS 'Preferred funder name
';
COMMENT ON COLUMN public.funder.acronyms
    IS 'Pipe separated list of funder acronyms (alternative names)';

CREATE TABLE public.funding (
    handle_title VARCHAR(25) NOT NULL,
    handle_funder VARCHAR(25) NOT NULL,
    PRIMARY KEY (handle_title, handle_funder)
);


COMMENT ON COLUMN public.funding.handle_funder
    IS 'A handle, e.g. 20.500.12657/14222';

CREATE TABLE public.publisher (
    handle VARCHAR(25) NOT NULL,
    name VARCHAR(100) NOT NULL,
    website VARCHAR(100),
    PRIMARY KEY (handle)
);


COMMENT ON COLUMN public.publisher.handle
    IS 'a handle, e.g. 20.500.12657/22403
(https://library.oapen.org/handle/20.500.12657/22403)';

CREATE TABLE public.contributor (
    name VARCHAR(100) NOT NULL,
    orcid char(19),
    PRIMARY KEY (name)
);


CREATE TABLE public.institution (
    id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    alt_names text NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE public.institution
    ADD UNIQUE (name);


COMMENT ON COLUMN public.institution.id
    IS 'Auto generated ID';

CREATE TABLE public.affiliation (
    id INTEGER NOT NULL,
    id_institution INTEGER NOT NULL,
    orcid char(19) NOT NULL,
    from_date date NOT NULL,
    until_date date NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE public.affiliation
    ADD UNIQUE (id_institution, orcid, from_date, until_date);


COMMENT ON COLUMN public.affiliation.id
    IS 'Auto generated ID';

CREATE TABLE public.grant_data (
    property VARCHAR(10) NOT NULL,
    value VARCHAR(255) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (property, value, handle_title)
);


COMMENT ON COLUMN public.grant_data.property
    IS 'PROGRAM, PROJECT, NUMBER, ACRONYM';

ALTER TABLE public.title ADD CONSTRAINT FK_title__handle_publisher FOREIGN KEY (handle_publisher) REFERENCES public.publisher(handle);
ALTER TABLE public.language ADD CONSTRAINT FK_language__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.export_chunk ADD CONSTRAINT FK_export_chunk__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.date_accessioned ADD CONSTRAINT FK_date_accessioned__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.contribution ADD CONSTRAINT FK_contribution__name_contributor FOREIGN KEY (name_contributor) REFERENCES public.contributor(name);
ALTER TABLE public.contribution ADD CONSTRAINT FK_contribution__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.identifier ADD CONSTRAINT FK_identifier__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.subject_other ADD CONSTRAINT FK_subject_other__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.subject_classification ADD CONSTRAINT FK_subject_classification__code_classification FOREIGN KEY (code_classification) REFERENCES public.classification(code);
ALTER TABLE public.subject_classification ADD CONSTRAINT FK_subject_classification__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.funding ADD CONSTRAINT FK_funding__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(sysid);
ALTER TABLE public.funding ADD CONSTRAINT FK_funding__handle_funder FOREIGN KEY (handle_funder) REFERENCES public.funder(handle);
ALTER TABLE public.affiliation ADD CONSTRAINT FK_affiliation__id_institution FOREIGN KEY (id_institution) REFERENCES public.institution(id);
ALTER TABLE public.affiliation ADD CONSTRAINT FK_affiliation__orcid FOREIGN KEY (orcid) REFERENCES public.contributor(orcid);
ALTER TABLE public.grant_data ADD CONSTRAINT FK_grant_data__handle_title FOREIGN KEY (handle_title) REFERENCES public.title(handle);