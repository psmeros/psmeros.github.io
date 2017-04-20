#!/bin/bash

folder="public_html"
cp -r "$folder" "$folder".bak


publicationFormat="'<li><p>' || Authors || ' ' || '<i>' || Title || '</i>' || ' ' || Conference || ' ' || PlaceTime || ' ' || case when like('%.pdf', Link)=1 then '[<a href=\"publications/' || Link || '\">pdf</a>]' else case when like('http%', Link)=1 then '[<a href=\"' || Link || '\">link</a>]' else '' end end || '</p></li>'"
categoryFormat="'<a id=\"' || replace(Category,\" \",\"\") || '\" href=\"#' || replace(Category,\" \",\"\") || '\">' || Category || '</a>'"

publications=`sqlite3 ../etc/psmerosDB "select '<p>' || $categoryFormat || '<br/>' || group_concat(publicationlist, ' ') || '</p>' from (
              select Category, CategoryID, Year, '<b>' || Year || '</b>' || '<ul>' || group_concat($publicationFormat,' ') || '</ul>' as publicationlist from publications, categories 
              WHERE ID=CategoryID group by CategoryID, Year order by Year DESC, Month DESC) tmp group by CategoryID order by CategoryID"`

publications=`echo "$publications" | sed 's/P. Smeros/\<b\>P. Smeros\<\/b\>/g'`


selectedPublicationFormat="'<li><p>' || Authors || ' ' || '<i>' || Title || '</i>' || ' ' || Conference || ' ' || PlaceTime || ' ' || case when like('%.pdf', Link)=1 then '[<a href=\"publications/' || Link || '\">pdf</a>]' else case when like('http%', Link)=1 then '[<a href=\"' || Link || '\">link</a>]' else '' end end || case when like('%.pdf', Slides)=1 then ' [<a href=\"publications/' || Slides || '\">slides</a>]' else '' end || '</p></li>'"

selectedPublications=`sqlite3 ../etc/psmerosDB "select '<ul>' || $selectedPublicationFormat || '</ul>' from publications WHERE Selected=1 order by Year DESC, Month DESC"`
selectedPublications=`echo "$selectedPublications" | sed 's/P. Smeros/\<b\>P. Smeros\<\/b\>/g'`


sed -i "s|?PUBLICATIONS?|`echo $publications`|g" "$folder"/allPublications.html
sed -i "s|?PUBLICATIONS?|`echo $selectedPublications`|g" "$folder"/index.html
sed -i "s|?DATE?|`date +%d/%m/%Y`|g" "$folder"/index.html


#List Deliverables (deprecated)
#deliverableFormat="'<li><p>' || Authors || ' ' || '<i>' || Title || '</i>' || ' ' || Info || '</p></li>'"
#deliverables=`sqlite3 ../etc/psmerosDB "select '<ul>' || $deliverableFormat || '</ul>' from deliverables
#              order by Year DESC, Priority"`
#deliverables=`echo "$deliverables" | sed 's/P. Smeros/\<b\>P. Smeros\<\/b\>/g'`
#sed -i "s|?DELIVERABLES?|`echo $deliverables`|g" "$folder"/index.html
