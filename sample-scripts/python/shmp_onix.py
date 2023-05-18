# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

from datetime import datetime
today: str = datetime.today().strftime('%Y%m%d')


def onix_wrap(s):
    from textwrap import dedent
    header = dedent('''\
        <?xml version="1.0" encoding="UTF-8"?>
        <ONIXMessage xmlns="http://ns.editeur.org/onix/3.0/reference" release="3.0">
        <Header>
        <Sender>
        <SenderName>OAPEN Foundation</SenderName>
        <EmailAddress>info@oapen.org</EmailAddress>
        </Sender>
        <SentDateTime>''' + today + '''</SentDateTime>
        </Header>
        ''')

    footer = '</ONIXMessage>'

    return header + s + footer


def run_a_query():
    query = '''
    SELECT
        content, "hallo"
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
    import mysql.connector
    connection = mysql.connector.connect(
        host="localhost",
        user="trilobiet",
        password="***REMOVED***",
        database="oapen_memo"
    )

    # connect and query
    cursor = connection.cursor()
    cursor.execute(query)
    records = cursor.fetchall()
    output = ''

    # concatenate
    for (row) in records:
        output += row[0].decode('utf-8')

    # add header + footer
    output = onix_wrap(output)

    # save
    text_file = open(f"onix-{today}.xml", "w")
    text_file.write(output)
    text_file.close()

    cursor.close()
    connection.close()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    run_a_query()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
