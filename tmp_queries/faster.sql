SELECT
    t.*,
    publisher.name AS publisher,
    GROUP_CONCAT(DISTINCT language.language SEPARATOR '; ') AS languages,

    (SELECT GROUP_CONCAT(DISTINCT identifier SEPARATOR '; ') FROM identifier id WHERE id.handle_title = t.handle AND identifier_type = 'ISBN') AS isbn,
    (SELECT GROUP_CONCAT(DISTINCT identifier SEPARATOR '; ') FROM identifier id WHERE id.handle_title = t.handle AND identifier_type = 'DOI') AS doi,
    (SELECT GROUP_CONCAT(DISTINCT identifier SEPARATOR '; ') FROM identifier id WHERE id.handle_title = t.handle AND identifier_type = 'OCN') AS ocn,

    (SELECT GROUP_CONCAT(DISTINCT name_contributor SEPARATOR '; ') FROM contribution cont WHERE cont.handle_title = t.handle AND role = 'author') AS authors,
    (SELECT GROUP_CONCAT(DISTINCT name_contributor SEPARATOR '; ') FROM contribution cont WHERE cont.handle_title = t.handle AND role = 'editor') AS editors,
    (SELECT GROUP_CONCAT(DISTINCT name_contributor SEPARATOR '; ') FROM contribution cont WHERE cont.handle_title = t.handle AND role = 'advisor') AS advisors,
    (SELECT GROUP_CONCAT(DISTINCT name_contributor SEPARATOR '; ') FROM contribution cont WHERE cont.handle_title = t.handle AND role = 'other') AS othercontributors,

    (SELECT GROUP_CONCAT(DISTINCT value SEPARATOR '; ') FROM grant_data gr WHERE gr.handle_title = t.handle AND property = 'number') AS funder_grant,

    GROUP_CONCAT(DISTINCT collection.collection SEPARATOR '; ') AS collections,
    GROUP_CONCAT(DISTINCT thema.code_classification SEPARATOR '; ') AS subject_classifications,
    GROUP_CONCAT(DISTINCT clx.description ORDER BY clx.code SEPARATOR "; ") AS subject_description,
    GROUP_CONCAT(DISTINCT funder.name SEPARATOR "; ") AS funder_name

FROM
    title t
    LEFT JOIN language ON t.handle = language.handle_title
    LEFT JOIN publisher ON t.handle_publisher = publisher.handle
    LEFT JOIN collection ON t.handle = collection.handle_title
    LEFT JOIN (subject_classification thema JOIN classification clx ON thema.code_classification = clx.code) ON t.handle = thema.handle_title
    LEFT JOIN (funding JOIN funder ON funder.handle = funding.handle_funder) ON funding.handle_title = t.handle

GROUP BY
	t.handle

ORDER BY
	t.timestamp desc

LIMIT
    100000
