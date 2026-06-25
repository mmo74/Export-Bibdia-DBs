#!/usr/bin/env bash


################################################################################
## Script zum Export der Bibdia-Daten für die Migratrion zu LMSCloud
## author: mmo
## change: 2020-09-23
## license: GPLv3 or any newer
##
## Das Script exportiert die Daten mithilfe von dbq. Dieses Tool gehört
## zu Bibdia bzw. zur sibas-Datenbank. Die Daten werden dabei im aktuellen
## Verzeichnis gespeichert und als ANSI-Textfiles abgelegt (für jeden REALM
## eine eigene Datei.
## HINWEIS:
## Bei Installationen mit sehr großen Tabellen (z.B. BENWERT mit Signotec-Daten
## kann es vorkommen, dass der Export mit dbq mit einem Integer-Overflow ab-
## bricht. In diesem Fall müssen die Tabellen jeweils einzeln per
## (dbq -x DBNAME REALM)
## bzw. für die zu große Tabelle über ein cbql-Scripte (MUSTER siehe unten) 
## exporttiert werden.
## 
################################################################################

EXPORTPATH=/home/user/LMS
OPAXPATH=/bibdia/user/opax

# Verzeichnis erstellen, wenn nötig
[ -d $EXPORTPATH ] || mkdir $EXPORTPATH


## Export der DBACQ
SIBASDB=dbacq
echo "################################################################################"
echo "Exportiere: $SIBASDB"
mkdir $EXPORTPATH/$SIBASDB
cd $EXPORTPATH/$SIBASDB
dbq -x $SIBASDB all execute
rm ./SIBAS-*
cd ..
tar -cjf ./$SIBASDB.tar.bz2 ./$SIBASDB
#rm ./$SIBASDB/ -r


## Export der DBBEN
SIBASDB=dbben
echo "################################################################################"
echo "Exportiere: $SIBASDB"
mkdir $EXPORTPATH/$SIBASDB
cd $EXPORTPATH/$SIBASDB
dbq -x $SIBASDB all execute
#rm ./SIBAS-*
cd ..
tar -cjf ./$SIBASDB.tar.bz2 ./$SIBASDB
#rm $SIBASDB/ -r

## Export der DBKAT
SIBASDB=dbkat
echo "################################################################################"
echo "Exportiere: $SIBASDB"
mkdir $EXPORTPATH/$SIBASDB
cd $EXPORTPATH/$SIBASDB
dbq -x $SIBASDB all execute
#rm ./SIBAS-*
cd ..
tar -cjf ./$SIBASDB.tar.bz2 ./$SIBASDB
#rm ./$SIBASDB/ -r


## Export der DBKLA
SIBASDB=dbkla
echo "################################################################################"
echo "Exportiere: $SIBASDB"
mkdir $EXPORTPATH/$SIBASDB
cd $EXPORTPATH/$SIBASDB
dbq -x $SIBASDB all execute
#rm ./SIBAS-*
cd ..
tar -cjf ./$SIBASDB.tar.bz2 ./$SIBASDB
#rm ./$SIBASDB/ -r


## Export der DBMED
SIBASDB=dbmed
echo "################################################################################"
echo "Exportiere: $SIBASDB"
mkdir $EXPORTPATH/$SIBASDB
cd $EXPORTPATH/$SIBASDB
dbq -x $SIBASDB all execute
#rm ./SIBAS-*
cd ..
tar -cjf ./$SIBASDB.tar.bz2 ./$SIBASDB
#rm ./$SIBASDB/ -r



## Export der DBSTAT
SIBASDB=dbstat
echo "################################################################################"
echo "Exportiere: $SIBASDB"
mkdir $EXPORTPATH/$SIBASDB
cd $EXPORTPATH/$SIBASDB
dbq -x $SIBASDB all execute
#rm ./SIBAS-*
cd ..
tar -cjf ./$SIBASDB.tar.bz2 ./$SIBASDB
#rm ./$SIBASDB/ -r



## Export der DBTXT
SIBASDB=dbtxt
echo "################################################################################"
echo "Exportiere: $SIBASDB"
mkdir $EXPORTPATH/$SIBASDB
cd $EXPORTPATH/$SIBASDB
dbq -x $SIBASDB all execute
#rm ./SIBAS-*
cd ..
tar -cjf ./$SIBASDB.tar.bz2 ./$SIBASDB
#rm ./$SIBASDB/ -r



################################################################################
## Zum leichteren Download verpacken wir die Archivdateien ein einen
## tar-Container und verschieben diesen nach /bibdia/user/opax/LMS.
## Der Container kann dann unter:
##  https://servername/opax/LMS/LMS_DATUM.tar.S
## heruntergeladen werden.
mkdir $OPAXPATH/LMS
tar cf $OPAXPATH/LMS/LMS_$(date "+%Y%m%d").tar $EXPORTPATH/*.tar.bz2


mkdir $EXPORTPATH/$(date "+%Y%m%d")
mv $EXPORTPATH/db* $EXPORTPATH/$(date "+%Y%m%d")


################################################################################
################################################################################
### cbql-Script-Template zum Export eines realms
###
### Es muss bekannt sein, wie der realm (die Tabelle) heißt und welche Felder
### in diesem realm gespeichert werden.
###
### cbql-Scripte tragen die Endung ".r", müssen compiliert werden und bekommen
### dann die Endung ".cmp"
###
### Compilieren mit:   cbql -a TERM GE c ./SCRIPTNAME.r     
###      (wobei TERM eine gültige Terminalnummer sein muss: versuch mal 100)
### nach dem Compilieren ausführen mit: cbql -a TERM GE a ./SCRIPTNAME.r     
###
###
### Nachfolgend das Template:


<<EOF


heading 'BENWERT exportieren';

var    outputfile file text,
       exportfile= 'BENWERT.txt' string;


(* **************************************************************************** *)
title  'export DBBEN.BENWERT';

(* Datei oeffnen oder Ende bei Fehler *)
if not openfile outputfile from @exportfile for write then
   write 'Kann Ausgabedatei ('&@exportfile&')nicht oeffnen';
   exit;
fi;

(* Header (1.Zeile des CSV-Files schreiben *)
put 'LINE_NR;OBJ_TYPE;TITEL_NR;WERT' to outputfile;

(* ueber alle Datensaetze itterieren *)
for each in realm BENWERT do
      (* Datensatz schreiben *)
      put LINE_NR & ';' & OBJ_TYPE & ';' & TITEL_NR & ';' & WERT to outputfile;
od;


(* eine Zeile ins Terminal schreiben, da sonst der Cursor am Zeilenende haengen bleibt *)
write '';

(* Datei schließen *)
closefile outputfile;

(* ENDE des cbql-Templates *)
(* ************************************************** *)

EOF





### Noch ein paar Hinweise:
### - ALLES in GROßBUCHSTABEN im obigen Script muss an den jeweiligen REALM 
###   angepasst werden
### - Kommentare in cbql:  (* Kommentar *)   können auch mehrzeilige sein
### - jedes cbql-Script muss mit heading 'irgendein TEXT' anfangen.
###   Der Text ist wurscht, ich schreib kurz wofür das Script gedacht ist
### Der Rest ist hoffentlich selbst erklärend
### 
### In diesem Sinne viel Spaß, KEINE PANIK und die Antwort ist 42!    ;-b
###
################################################################################
