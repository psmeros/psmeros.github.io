#!/bin/bash
#Requires SQLite and sshfs.

sqlite3 publicationDB ".mode csv"
sqlite3 publicationDB ".separator \"|\""
sqlite3 publicationDB ".import etc/publications.csv publications"
sqlite3 publicationDB ".import etc/categories.csv categories"
sqlite3 publicationDB ".mode tabs"

publicationFormat="'<li><p>' || Authors || ' ' || '<i>' || Title || '</i>' || ' ' || Conference || ' ' || PlaceTime || ' ' || Link || '</p></li>'"
categoryFormat="'<a id=\"' || replace(Category,\" \",\"\") || '\" href=\"#' || replace(Category,\" \",\"\") || '\">' || Category || '</a>'"

publications=`sqlite3 publicationDB "select '<p>' || $categoryFormat || '<br/>' || group_concat(publicationlist, ' ') || '</p>' from (
              select Category, CategoryID, Year, '<b>' || Year || '</b>' || '<ul>' || group_concat($publicationFormat,' ') || '</ul>' as publicationlist from publications, categories 
              WHERE ID=CategoryID group by CategoryID, Year order by Year DESC, Month DESC) tmp group by CategoryID order by CategoryID"`

publications=`echo "$publications" | sed 's/P. Smeros/\<b\>P. Smeros\<\/b\>/g'`

rm publicationDB


sudo mkdir tmp
sudo sshfs psmeros@users.uoa.gr: tmp
sudo rm -r tmp/public_html
sudo cp -r public_html tmp/
sudo sed -i "s|?PUBLICATIONS?|`echo $publications`|g" tmp/public_html/index.html
sudo sed -i "s|?DATE?|`date +%d/%m/%Y`|g" tmp/public_html/index.html
sudo umount tmp
sudo rm -r tmp


