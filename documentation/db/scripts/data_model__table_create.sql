CREATE TABLE public.title (
    id UUID NOT NULL,
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
    oapen_identifier_doi VARCHAR(100),
    oapen_identifier_ocn VARCHAR(15),
    oapen_imprint VARCHAR(100),
    oapen_pages INTEGER,
    oapen_placepublication VARCHAR(100),
    oapen_relation_partofbook UUID NOT NULL,
    oapen_relation_ispublishedby VARCHAR(25),
    oapen_relation_ispublishedby_publishername  NOT NULL,
    oapen_seriesnumber VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE INDEX part_of_oapen_relation_partofbook ON public.title
    (oapen_relation_partofbook);


COMMENT ON COLUMN public.title.handle
    IS 'Handle (without url part), e.g. 20.500.12657/53113';
COMMENT ON COLUMN public.title.collection_no
    IS 'e.g. 20.500.12657/8 
TODO: where can this be found in the API?';
COMMENT ON COLUMN public.title.download_url
    IS 'E.g. /rest/bitstreams/ea7d1f20-5fa6-4d43-8307-22f9b40e2fbb/retrieve';
COMMENT ON COLUMN public.title.thumbnail
    IS 'e.g. m.celama-eb.5.120678.cover.jpg

Json path: 
(List) $.[{row}].bitstreams[?(@.bundleName == ''THUMBNAIL'')].name
';
COMMENT ON COLUMN public.title.dc_type
    IS 'book OR chapter';
COMMENT ON COLUMN public.title.oapen_relation_ispublishedby
    IS 'Json Path:

(Object) $.[row].metadata[?(@.key == ''oapen.relation.isPublishedBy'')]

(Object) $.[0].metadata[?(@.key == ''publisher.name'')]';

CREATE TABLE public.dc_language (
    language VARCHAR(10) NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (language, id_title)
);


CREATE TABLE public.export_chunk (
    type VARCHAR(10) NOT NULL,
    id_title UUID NOT NULL,
    content text NOT NULL,
    PRIMARY KEY (type, id_title)
);


CREATE TABLE public.dc_date_accessioned (
    date DATETIME NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (date, id_title)
);


CREATE TABLE public.identifier_isbn (
    isbn VARCHAR(15) NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (isbn)
);

CREATE INDEX part_of_id_title ON public.identifier_isbn
    (id_title);


CREATE TABLE public.dc_contributor (
    name VARCHAR(100) NOT NULL,
    id_title UUID NOT NULL,
    type VARCHAR(10) NOT NULL,
    PRIMARY KEY (name, id_title)
);


CREATE TABLE public.oapen_identifier (
    identifier VARCHAR(50) NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (identifier)
);

CREATE INDEX part_of_id_title ON public.oapen_identifier
    (id_title);


CREATE TABLE public.classification (
    id VARCHAR(5) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);


CREATE TABLE public.dc_subject_other (
    subject VARCHAR(100) NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (subject)
);

CREATE INDEX part_of_id_title ON public.dc_subject_other
    (id_title);


CREATE TABLE public. (
);


CREATE TABLE public.dc_subject_classification (
    id_classification VARCHAR(5) NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (id_classification, id_title)
);


CREATE TABLE public.funder (
    id VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);


COMMENT ON COLUMN public.funder.id
    IS 'A handle, e.g. 20.500.12657/14222
(https://library.oapen.org/handle/20.500.12657/14222)';

CREATE TABLE public.oapen_relation_isfundedby (
    grant_number VARCHAR(100) NOT NULL,
    grant_program VARCHAR(255),
    grant_project VARCHAR(255),
    grant_acronym VARCHAR(100),
    id_funder VARCHAR(25) NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (grant_number)
);

CREATE INDEX part_of_id_funder ON public.oapen_relation_isfundedby
    (id_funder);
CREATE INDEX part_of_id_title ON public.oapen_relation_isfundedby
    (id_title);


CREATE TABLE public.funder_name (
    name VARCHAR(255) NOT NULL,
    id_funder VARCHAR(25) NOT NULL,
    PRIMARY KEY (name)
);

CREATE INDEX part_of_id_funder ON public.funder_name
    (id_funder);


CREATE TABLE public.publisher (
    id VARCHAR(25) NOT NULL,
    name VARCHAR(100) NOT NULL,
    website VARCHAR(100),
    PRIMARY KEY (id)
);


COMMENT ON COLUMN public.publisher.id
    IS 'a handle, e.g. 20.500.12657/22403
(https://library.oapen.org/handle/20.500.12657/22403)';

CREATE TABLE public.oapen_relation_ispublishedby (
    id_publisher VARCHAR(25) NOT NULL,
    id_title UUID NOT NULL,
    PRIMARY KEY (id_publisher, id_title)
);


ALTER TABLE public.title ADD CONSTRAINT FK_title__oapen_relation_partofbook FOREIGN KEY (oapen_relation_partofbook) REFERENCES public.title(id);
ALTER TABLE public.export_chunk ADD CONSTRAINT FK_export_chunk__id_title FOREIGN KEY (id_title) REFERENCES public.title(id);
ALTER TABLE public.dc_date_accessioned ADD CONSTRAINT FK_dc_date_accessioned__id_title FOREIGN KEY (id_title) REFERENCES public.title(id);
ALTER TABLE public.identifier_isbn ADD CONSTRAINT FK_identifier_isbn__id_title FOREIGN KEY (id_title) REFERENCES public.title(id);
ALTER TABLE public.dc_contributor ADD CONSTRAINT FK_dc_contributor__id_title FOREIGN KEY (id_title) REFERENCES public.title(id);
ALTER TABLE public.oapen_identifier ADD CONSTRAINT FK_oapen_identifier__id_title FOREIGN KEY (id_title) REFERENCES public.title(id);
ALTER TABLE public.dc_subject_classification ADD CONSTRAINT FK_dc_subject_classification__id_classification FOREIGN KEY (id_classification) REFERENCES public.classification(id);
ALTER TABLE public.dc_subject_classification ADD CONSTRAINT FK_dc_subject_classification__id_title FOREIGN KEY (id_title) REFERENCES public.title(id);
ALTER TABLE public.oapen_relation_isfundedby ADD CONSTRAINT FK_oapen_relation_isfundedby__id_funder FOREIGN KEY (id_funder) REFERENCES public.funder(id);
ALTER TABLE public.oapen_relation_isfundedby ADD CONSTRAINT FK_oapen_relation_isfundedby__id_title FOREIGN KEY (id_title) REFERENCES public.title(id);
ALTER TABLE public.funder_name ADD CONSTRAINT FK_funder_name__id_funder FOREIGN KEY (id_funder) REFERENCES public.funder(id);