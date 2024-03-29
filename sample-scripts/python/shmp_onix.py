# This is a sample Python script.
# Run a query, concatenate the results and save as a file.

from datetime import datetime
today: str = datetime.today().strftime('%Y%m%d')

from queries import shmp_onix
from sniplets import mysql_connect

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

    connection = mysql_connect.connection

    # connect and query
    cursor = mysql_connect.connection.cursor()
    cursor.execute(shmp_onix.query)
    records = cursor.fetchall()
    output = ''

    # concatenate
    for (row) in records:
        output += row[0]

    # add header + footer
    output = onix_wrap(output)

    # save
    text_file = open(f"onix-{today}.xml", "w", encoding="utf-8")
    text_file.write(output)
    text_file.close()

    cursor.close()
    connection.close()
    
    print('OK')


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    run_a_query()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
