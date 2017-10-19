import pandas as pd
import os

author = 'P. Smeros'
publications_file = 'publications.tsv'
categories_file = 'categories.tsv'
placeholder = segment = '<!--//PUBLICATIONS!!-->'
publications_html = '../allPublications.html'
index_html = '../index.html'


pd.set_option('isplay.max_colwidth', -1)

publications = pd.read_csv(publications_file, sep='\t')
categories = pd.read_csv(categories_file, sep='\t')

#Bold author's name
publications.Authors = publications.Authors.apply(lambda x : x.replace(author, '<b>' + author + '</b>'))

#Column transformation
publications.Authors = publications.Authors + ' '
publications.Title = '<i>' + publications.Title + '</i>' + ' '
publications.Conference = publications.Conference + ' '
publications.PlaceTime = publications.PlaceTime + ' '
publications.PDF = publications.PDF.apply(lambda x : '[<a href=\"publications/' + x + '\">pdf</a>]' if x.endswith('.pdf') else '[<a href=\"' + x + '\">link</a>]' if x.startswith('http') else '')
publications.Slides = publications.Slides.apply(lambda x : ' ' + '[<a href=\"publications/' + x + '\">slides</a>]' if pd.notnull(x) else '')

#Column concatenation
publications['concatenation'] = '<li>' + publications.Authors + publications.Title + publications.Conference + publications.PlaceTime + publications.PDF + publications.Slides + '<br/> </li>'

#Pretty print
publications = publications[['CategoryID', 'Year', 'Month', 'Selected', 'concatenation']].sort_values(['CategoryID', 'Year', 'Month'], ascending=[True, False, False])
categories = categories.set_index('ID')
for category, group1 in publications.groupby(['CategoryID'], sort=False):
	segment += '<h4>' + categories.loc[category]['Category'] + '</h4>'
	for year, group2 in group1.groupby(['Year'], sort=False):
 		segment += '<p>' + str(year) + '</p>'
 		segment += '<ul>'
 		segment += group2['concatenation'].str.cat(sep='')
 		segment += '</ul>'
segment ='\t\t\t\t' + segment + '\n'

#Replace placeholder on 'publications_html' file
with open(publications_html, 'r') as input_file, open(publications_html+'.tmp', 'w') as output_file:
    for line in input_file:
        if line.strip().startswith(placeholder):
            output_file.write(segment)
        else:
            output_file.write(line)
os.rename(publications_html+'.tmp', publications_html)

#Filter non selected publications
publications = publications[publications.Selected == True]
publications['concatenation'] = publications['concatenation'].apply(lambda x: x.replace('<li>', '<p>').replace('<br/> </li>', '</p>')) 

#Pretty print
segment = '<!--//PUBLICATIONS!!-->'
segment += publications['concatenation'].str.cat(sep='')
segment ='\t\t\t\t\t' + segment + '\n'

#Replace placeholder on 'index_html' file
with open(index_html, 'r') as input_file, open(index_html+'.tmp', 'w') as output_file:
    for line in input_file:
        if line.strip().startswith(placeholder):
            output_file.write(segment)
        else:
            output_file.write(line)
os.rename(index_html+'.tmp', index_html)