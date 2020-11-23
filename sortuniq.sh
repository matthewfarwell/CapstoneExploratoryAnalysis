outfile=${1}
shift

(echo 'n,ngram'; sort ${@} | uniq -c | sort -nr | sed 's/^ *\([0-9][0-9]*\)  */\1,/') > ${outfile}


