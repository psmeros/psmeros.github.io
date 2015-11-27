#!/bin/bash
#Requires SQLite and sshfs.

folder="public_html"
cp -r "$folder" "$folder".bak

sqlite3 publicationsDB ".mode csv"
sqlite3 publicationsDB ".separator \"|\""
sqlite3 publicationsDB ".import ../etc/publications.csv publications"
sqlite3 publicationsDB ".import ../etc/categories.csv categories"
sqlite3 publicationsDB ".mode tabs"

publicationFormat="'<li><p>' || Authors || ' ' || '<i>' || Title || '</i>' || ' ' || Conference || ' ' || PlaceTime || ' ' || case when like('%.pdf', Link)=1 then '[<a href=\"' || Link || '\">pdf</a>]' else case when like('http%', Link)=1 then '[<a href=\"' || Link || '\">link</a>]' else '' end end || '</p></li>'"
categoryFormat="'<a id=\"' || replace(Category,\" \",\"\") || '\" href=\"#' || replace(Category,\" \",\"\") || '\">' || Category || '</a>'"

publications=`sqlite3 publicationsDB "select '<p>' || $categoryFormat || '<br/>' || group_concat(publicationlist, ' ') || '</p>' from (
              select Category, CategoryID, Year, '<b>' || Year || '</b>' || '<ul>' || group_concat($publicationFormat,' ') || '</ul>' as publicationlist from publications, categories 
              WHERE ID=CategoryID group by CategoryID, Year order by Year DESC, Month DESC) tmp group by CategoryID order by CategoryID"`

publications=`echo "$publications" | sed 's/P. Smeros/\<b\>P. Smeros\<\/b\>/g'`

rm publicationsDB


sqlite3 deliverablesDB ".mode csv"
sqlite3 deliverablesDB ".separator \"|\""
sqlite3 deliverablesDB ".import ../etc/deliverables.csv deliverables"
sqlite3 deliverablesDB ".mode tabs"

deliverableFormat="'<li><p>' || Authors || ' ' || '<i>' || Title || '</i>' || ' ' || Info || '</p></li>'"

deliverables=`sqlite3 deliverablesDB "select '<ul>' || $deliverableFormat || '</ul>' from deliverables
              order by Year DESC, Priority"`

deliverables=`echo "$deliverables" | sed 's/P. Smeros/\<b\>P. Smeros\<\/b\>/g'`

rm deliverablesDB



sed -i "s|?PUBLICATIONS?|`echo $publications`|g" "$folder"/index.html
sed -i "s|?DELIVERABLES?|`echo $deliverables`|g" "$folder"/index.html
sed -i "s|?DATE?|`date +%d/%m/%Y`|g" "$folder"/index.html


