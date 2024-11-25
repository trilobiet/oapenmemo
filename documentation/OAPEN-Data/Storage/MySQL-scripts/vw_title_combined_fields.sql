CREATE
    ALGORITHM = UNDEFINED
    DEFINER = trilobiet@localhost
    SQL SECURITY DEFINER
VIEW title_combined_fields AS
SELECT
    title.handle as handle_title,
    publisher.name as publisher,
    group_concat(distinct author.name_contributor separator "; ") as authors,
    group_concat(distinct editor.name_contributor separator "; ") as editors,
    group_concat(distinct other.name_contributor separator "; ") as othercontributors,
    group_concat(distinct advisor.name_contributor separator "; ") as advisors,
    group_concat(distinct subject_classification.code_classification separator "; ") as subject_classifications,
    group_concat(distinct collection.collection separator "; ") as collections,
    group_concat(distinct language.language separator "; ") as languages
FROM
    title
    LEFT JOIN publisher ON title.handle_publisher = publisher.handle
    LEFT JOIN contribution author ON title.handle = author.handle_title AND author.role = 'author'
    LEFT JOIN contribution editor ON title.handle = editor.handle_title AND editor.role = 'editor'
    LEFT JOIN contribution other ON title.handle = other.handle_title AND editor.role = 'other'
    LEFT JOIN contribution advisor ON title.handle = advisor.handle_title AND advisor.role = 'advisor'
    LEFT JOIN subject_classification ON subject_classification.handle_title = title.handle
    LEFT JOIN collection ON collection.handle_title = title.handle
    LEFT JOIN language ON language.handle_title = title.handle
GROUP BY
	title.handle
