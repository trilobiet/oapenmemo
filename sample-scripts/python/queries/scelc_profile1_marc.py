query = '''
SELECT
    marcxml.content as marcxml
FROM
	title
    JOIN language lan on lan.handle_title = handle
    JOIN subject_classification cla on cla.handle_title = handle
    LEFT JOIN export_chunk marcxml on marcxml.handle_title = handle AND marcxml.type = 'MARCXML'
WHERE
	title.type = 'book'
    AND marcxml.content is not null
    AND NOT (download_url is null OR trim(download_url = ''))
    AND lan.language in ('eng','spa','chi','ger','gre','heb','jpn','por','kor')
    AND cla.code_classification = 'HR'
GROUP BY
	handle
ORDER by
	handle
'''

