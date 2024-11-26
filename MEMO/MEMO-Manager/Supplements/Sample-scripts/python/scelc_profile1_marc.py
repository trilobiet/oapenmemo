# This is a sample Python script.
# Run a query, concatenate the results and save as a file.

from datetime import datetime
today: str = datetime.today().strftime('%Y%m%d')

from queries import scelc_profile1_marc
from sniplets import mysql_connect
from sniplets import marc21

def run_a_query():

    connection = mysql_connect.connection

    # connect and query
    cursor = mysql_connect.connection.cursor()
    cursor.execute(scelc_profile1_marc.query)
    records = cursor.fetchall()
    output = ''

    # concatenate
    for (row) in records:
        output += row[0]

    # add header + footer
    output = marc21.wrap_in_header_footer(output)

    return output

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print( run_a_query() )

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
