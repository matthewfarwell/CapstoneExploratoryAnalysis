file=${1}
outfile=${2}


tr -d '_' < ${file} | tr -dc '\0-\177' | tr 'A-Z\000' 'a-z ' > ${outfile}

