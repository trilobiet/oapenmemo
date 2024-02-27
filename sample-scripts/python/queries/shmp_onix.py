query = '''
SELECT
    content
FROM
    title t
    JOIN collection col on col.handle_title = t.handle
    JOIN export_chunk onix on onix.handle_title = t.handle AND onix.type = 'ONIX'
WHERE
    NOT (download_url is null OR trim(download_url = ''))
    AND col.collection = 'Sustainable History Monograph Pilot (SHMP)'
GROUP BY
    t.handle
ORDER by
    t.year_available desc, t.handle
'''
