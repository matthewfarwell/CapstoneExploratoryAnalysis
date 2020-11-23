library(quanteda)
library(stringr)


preProcess <- function(textFile, outputFile) {
  if (!file.exists(outputFile)) {
    system2("./preprocess.sh", args = c(textFile, outputFile))
  }
}

summarise <- function(outputFile) {
  if (!file.exists(outputFile)) {
    system2("./summarise.sh", args = c(outputFile))
  }
}


sortuniq <- function(outputFile, files) {
  if (!file.exists(outputFile)) {
    print(paste("sortuniq", outputFile, paste(files, collapse=" ")))

    system2("./sortuniq.sh", args = c(outputFile, files))
  }
}

processNgrams <- function(lineTokens, outCon, numberNgrams) {
  ngrams <- tokens_ngrams(lineTokens, n = numberNgrams)

  for (i in 1:length(ngrams)) {
    for (x in ngrams[[i]]) {
      if (!is.na(x) && length(x) > 0) {
        write(x[1], file=outCon, append=TRUE)
      }
    }
  }
}

processLines <- function(textFile, lines, outCons, ngrams) {
  lineTokens <- tokens(lines, include_docvars = FALSE, remove_numbers = TRUE, remove_punct = TRUE, remove_symbols=TRUE, remove_url=TRUE)

  for (i in 1:length(ngrams)) {
    processNgrams(lineTokens, outCons[[i]], ngrams[i])
  }
}

genNgramsFile <- function(textFile, outputDir, prefix, ngramFilesFn, ngrams) {
  count <- 0
  numberOfLines <- 1000
  maxLines <- numberOfLines * 10 * -1

  print(paste("processing", textFile, "ngrams", as.character(ngrams)))

  outputFiles <- sapply(ngrams, function(nn) { ngramFilesFn(outputDir, prefix, nn) })
  exists <- sapply(outputFiles, function(of) { file.exists(of)})

  ngrams <- ngrams[!exists]
  modOutputFiles <- outputFiles[!exists]

  if (length(ngrams) > 0) {
    inCon = file(textFile, "r")

    outCons = lapply(modOutputFiles, function(x) { file(x, "w") })

    while (TRUE) {
      if (maxLines > 0 && count >= maxLines ) {
        break
      }
      lines = readLines(inCon, numberOfLines)

      count <- count + length(lines)
      if (length(lines) == 0) {
        break
      }

      print(paste(textFile, as.character(count), "lines"))

      processLines(textFile, lines, outCons, ngrams)
    }
    
    close(inCon)

    sapply(outCons, function(x) { close(x) })
  }


  outputFiles
}
