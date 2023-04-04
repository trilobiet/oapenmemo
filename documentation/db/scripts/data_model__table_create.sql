CREATE TABLE public.title (
    handle VARCHAR(25) NOT NULL,
    sysid VARCHAR(36),
    collection VARCHAR(25),
    handle_publisher VARCHAR(25),
    part_of_book VARCHAR(36),
    type VARCHAR(10),
    year_available INT(4),
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
    PRIMARY KEY (handle)
);

CREATE INDEX part_of_handle_publisher ON public.title
    (handle_publisher);


COMMENT ON COLUMN public.title.handle
    IS 'Handle (without url part), e.g. 20.500.12657/53113';
COMMENT ON COLUMN public.title.sysid
    IS 'UUID as used in DSpace.';
COMMENT ON COLUMN public.title.collection
    IS 'e.g. 20.500.12657/8 
TODO: where can this be found in the API?';
COMMENT ON COLUMN public.title.handle_publisher
    IS 'Json Path:

(Object) $.[row].metadata[?(@.key == ''oapen.relation.isPublishedBy'')]

(Object) $.[0].metadata[?(@.key == ''publisher.name'')]';
COMMENT ON COLUMN public.title.part_of_book
    IS 'UUID or handle';
COMMENT ON COLUMN public.title.type
    IS 'book OR chapter';
COMMENT ON COLUMN public.title.download_url
    IS 'E.g. /rest/bitstreams/ea7d1f20-5fa6-4d43-8307-22f9b40e2fbb/retrieve';
COMMENT ON COLUMN public.title.thumbnail
    IS 'e.g. m.celama-eb.5.120678.cover.jpg

Json path: 
(List) $.[{row}].bitstreams[?(@.bundleName == ''THUMBNAIL'')].name
';

CREATE TABLE public.language (
    language VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (language, handle_title)
);


CREATE TABLE public.export_chunk (
    type VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    content text NOT NULL,
    PRIMARY KEY (type, handle_title)
);


CREATE TABLE public.contribution (
    role VARCHAR(10) NOT NULL,
    name_contributor VARCHAR(255) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (role, name_contributor, handle_title)
);


COMMENT ON COLUMN public.contribution.role
    IS 'Advisor || Author || Editor || Other';

CREATE TABLE public.identifier (
    identifier VARCHAR(100) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    identifier_type VARCHAR(10) NOT NULL,
    PRIMARY KEY (identifier)
);

CREATE INDEX part_of_handle_title ON public.identifier
    (handle_title);


COMMENT ON TABLE public.identifier
    IS 'All sorts of identifiers for a title (ISBN, ISSN, OCN, DOI).';
COMMENT ON COLUMN public.identifier.identifier_type
    IS 'ISBN, ISSN, OCN, DOI';

CREATE TABLE public.classification (
    code VARCHAR(10) NOT NULL,
    description text NOT NULL,
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


COMMENT ON COLUMN public.subject_other.subject
    IS 'When two equal subjects appear with differnt casing (''Nation'' and ''nation'') within a single handle_title this will cause an integrity violation.

Therefore make this field case sensitive:
CHARACTER SET utf8 COLLATE utf8_bin
';

CREATE TABLE public.subject_classification (
    code_classification VARCHAR(10) NOT NULL,
    handle_title VARCHAR(25) NOT NULL,
    PRIMARY KEY (code_classification, handle_title)
);


CREATE TABLE public.funder (
    handle VARCHAR(25) NOT NULL,
    name text NOT NULL,
    acronyms text,
    number text,
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
    name text NOT NULL,
    website text,
    PRIMARY KEY (handle)
);


COMMENT ON COLUMN public.publisher.handle
    IS 'a handle, e.g. 20.500.12657/22403
(https://library.oapen.org/handle/20.500.12657/22403)';

CREATE TABLE public.contributor (
    name VARCHAR(255) NOT NULL,
    orcid char(19),
    PRIMARY KEY (name)
);

ALTER TABLE public.contributor
    ADD UNIQUE (orcid);


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

ALTER TABLE `oapen_memo`.`title` 
ADD COLUMN `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE `oapen_memo`.`export_chunk` 
ADD COLUMN `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
