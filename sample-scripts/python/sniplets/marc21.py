
def wrap_in_header_footer(s):
    from textwrap import dedent
    header = dedent('''\
        <?xml version="1.0" encoding="UTF-8"?>
        <marc:collection xmlns:marc="http://www.loc.gov/MARC21/slim">
        ''')

    footer = '</marc:collection>'

    return header + s + footer

