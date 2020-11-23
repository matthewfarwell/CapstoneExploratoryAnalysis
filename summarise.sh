outfile=${1}

echo "count,lang,type" > ${outfile}

wc -l gen/*.pre | grep -v total | sed \
  -e 's/.txt.pre//' \
  -e 's;gen/;;' \
  -e 's/^ *//g' \
  -e 's/\./ /g' \
  | awk '{print $1, $3, $4}' | tr ' ' ',' >> ${outfile}


wc -l gen/*.[123].csv | grep -v total | sed \
  -e 's/\([123]\).csv/ngrams_\1/' \
  -e 's;gen/;;' \
  -e 's/^ *//g' \
  -e 's/\./ /g' \
  | tr ' ' ',' >> ${outfile}

