SELECT
    t.*,
    publisher.name AS publisher,
    GROUP_CONCAT(DISTINCT language.language SEPARATOR '; ') AS languages,
	GROUP_CONCAT(DISTINCT isbn.identifier SEPARATOR '; ') AS isbn,
    GROUP_CONCAT(DISTINCT doi.identifier SEPARATOR '; ') AS doi,
    GROUP_CONCAT(DISTINCT ocn.identifier SEPARATOR '; ') AS ocn,
    GROUP_CONCAT(DISTINCT author.name_contributor  SEPARATOR '; ') AS authors,
    GROUP_CONCAT(DISTINCT editor.name_contributor  SEPARATOR '; ') AS editors,
    GROUP_CONCAT(DISTINCT other.name_contributor   SEPARATOR '; ') AS othercontributors,
    GROUP_CONCAT(DISTINCT advisor.name_contributor SEPARATOR '; ') AS advisors,
    GROUP_CONCAT(DISTINCT collection.collection SEPARATOR '; ') AS collections,
    GROUP_CONCAT(DISTINCT thema.code_classification SEPARATOR '; ') AS subject_classifications,
    GROUP_CONCAT(DISTINCT clx.description ORDER BY clx.code SEPARATOR "; ") AS subject_description,
    GROUP_CONCAT(DISTINCT funname.name SEPARATOR "; ") AS funder_name,
    GROUP_CONCAT(DISTINCT funder_grant.value SEPARATOR "; ") AS funder_grant
FROM
    title t
    LEFT JOIN publisher ON t.handle_publisher = publisher.handle
    LEFT JOIN collection ON t.handle = collection.handle_title
    LEFT JOIN (subject_classification thema JOIN classification clx ON thema.code_classification = clx.code) ON t.handle = thema.handle_title
    LEFT JOIN (funding fun JOIN funder funname ON funname.handle = fun.handle_funder) ON fun.handle_title = t.handle
    LEFT JOIN grant_data funder_grant ON funder_grant.handle_title = t.handle AND funder_grant.property = "number"
    LEFT JOIN contribution author ON t.handle = author.handle_title AND author.role = 'author'
    LEFT JOIN contribution editor ON t.handle = editor.handle_title AND editor.role = 'editor'
    LEFT JOIN contribution advisor ON t.handle = advisor.handle_title AND advisor.role = 'advisor'
    LEFT JOIN contribution other ON t.handle = other.handle_title AND editor.role = 'other'
    # add ISBN, DOI, OCN
	LEFT JOIN identifier isbn ON isbn.handle_title = t.handle AND isbn.identifier_type = "ISBN"
	LEFT JOIN identifier doi ON doi.handle_title = t.handle AND doi.identifier_type = "DOI"
    LEFT JOIN identifier ocn ON ocn.handle_title = t.handle AND ocn.identifier_type = "OCN"
    LEFT JOIN language ON t.handle = language.handle_title
GROUP BY
	t.handle
ORDER BY
	t.timestamp desc
LIMIT 100000
