 
SELECT
	title.*, group_concat(subject) as subjects

FROM
	title
    RIGHT JOIN subject_other ON handle = handle_title

WHERE
	MATCH(title, title_alternative)
    AGAINST('comic* OR cartoon*' in boolean mode)

    OR
	MATCH(description_abstract)
    AGAINST('comic* OR cartoon*' in boolean mode)

    OR
    MATCH(subject_other.subject)
    AGAINST('comic* OR cartoon*' in boolean mode)

GROUP BY
	handle

ORDER BY
    handle

