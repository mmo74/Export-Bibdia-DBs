author: mmo  
change: 2020-09-23  
license: GPLv3 or any newer  

# English
## Export-Bibdia-DBs
This script exports the required bibdia-databases (SIBAS-dbms)  to ANSI-textfiles.



# German
Script zum Export der Bibdia-Daten für die Migratrion zu LMSCloud

Das Script exportiert die Daten mithilfe von dbq. Dieses Tool gehört zu Bibdia bzw. zur sibas-Datenbank. Die Daten werden dabei im aktuellen Verzeichnis gespeichert und als ANSI-Textfiles abgelegt (für jeden REALM eine eigene Datei.

**HINWEIS:**  
Bei Installationen mit sehr großen Tabellen (z.B. BENWERT mit Signotec-Daten
kann es vorkommen, dass der Export mit dbq mit einem Integer-Overflow ab-
bricht. In diesem Fall müssen die Tabellen jeweils einzeln per
(dbq -x DBNAME REALM)
bzw. für die zu große Tabelle über ein cbql-Scripte (MUSTER siehe unten) 
exporttiert werden.
 
