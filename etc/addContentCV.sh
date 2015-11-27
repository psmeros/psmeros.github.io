#!/bin/bash
#Requires SQLite and sshfs.

file="psmerosCV.tex"
cp "$file" "$file".bak

sqlite3 publicationsDB ".mode csv"
sqlite3 publicationsDB ".separator \"|\""
sqlite3 publicationsDB ".import ../etc/publications.csv publications"
sqlite3 publicationsDB ".import ../etc/categories.csv categories"
sqlite3 publicationsDB ".mode tabs"

publications=`sqlite3 publicationsDB "select '\\\\\subsection{\\\\\\newline ' || Category || '}' || group_concat(publicationlist, ' ') from (
              select Category, CategoryID, Year, '\\\\\cvdate{' || Year || '}' || group_concat('\\\\\publication{' || Authors || ' ' || '\\\\\\textit{' || Title || '}' || ' ' || Conference || ' ' || PlaceTime || '}{' || Link || '}',' ') as publicationlist from publications, categories 
              WHERE ID=CategoryID group by CategoryID, Year order by Year DESC, Month DESC) tmp group by CategoryID order by CategoryID"`

publications=`echo "$publications" | sed 's/P. Smeros/\\\\\\\textbf{P. Smeros}/g'`

rm publicationsDB


sqlite3 deliverablesDB ".mode csv"
sqlite3 deliverablesDB ".separator \"|\""
sqlite3 deliverablesDB ".import ../etc/deliverables.csv deliverables"
sqlite3 deliverablesDB ".mode tabs"

deliverableFormat=""

deliverables=`sqlite3 deliverablesDB "select '\\\\\report{' || Authors || ' ' || '\\\\\\textit{' || Title || '}' || ' ' || Info || '}' from deliverables
              order by Year DESC, Priority"`

deliverables=`echo "$deliverables" | sed 's/P. Smeros/\\\\\\\textbf{P. Smeros}/g'`

rm deliverablesDB

sed -i "s|?PUBLICATIONS?|`echo $publications`|g" "$file"
sed -i "s|?DELIVERABLES?|`echo $deliverables`|g" "$file"


