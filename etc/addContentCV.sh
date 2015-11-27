#!/bin/bash

file="psmerosCV.tex"
cp "$file" "$file".bak


publications=`sqlite3 ../etc/psmerosDB "select '\\\\\subsection{\\\\\\newline ' || Category || '}' || group_concat(publicationlist, ' ') from (
              select Category, CategoryID, Year, '\\\\\cvdate{' || Year || '}' || group_concat('\\\\\publication{' || Authors || ' ' || '\\\\\\textit{' || Title || '}' || ' ' || Conference || ' ' || PlaceTime || '}{' || Link || '}',' ') as publicationlist from publications, categories 
              WHERE ID=CategoryID group by CategoryID, Year order by Year DESC, Month DESC) tmp group by CategoryID order by CategoryID"`

publications=`echo "$publications" | sed 's/P. Smeros/\\\\\\\textbf{P. Smeros}/g'`


deliverables=`sqlite3 ../etc/psmerosDB "select '\\\\\report{' || Authors || ' ' || '\\\\\\textit{' || Title || '}' || ' ' || Info || '}' from deliverables
              order by Year DESC, Priority"`

deliverables=`echo "$deliverables" | sed 's/P. Smeros/\\\\\\\textbf{P. Smeros}/g'`


sed -i "s|?PUBLICATIONS?|`echo $publications`|g" "$file"
sed -i "s|?DELIVERABLES?|`echo $deliverables`|g" "$file"


