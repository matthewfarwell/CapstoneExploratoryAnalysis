library(quanteda)
library(stringr)
library(dplyr)

# download the data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

source("files.R")
source("ngrams.R")

dataDir <- file.path("data")
outputDir <- file.path("gen")
originalDatafile <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
finalDir <- file.path(dataDir, "final")

zipFilename <- gsub(".*/(.*)", "\\1", originalDatafile)
zipPath <- file.path(dataDir, zipFilename)
documentSummary <- file.path(outputDir, "documents.csv")

createDir(dataDir)
createDir(outputDir)

downloadTo(originalDatafile, zipPath)

unzipTo(zipPath, dataDir, finalDir)

ngramFiles <- function(outputDir, prefix, nn) {
  file.path(outputDir, paste(prefix, ".", as.character(nn), ".ngrams", sep=""))
}

genNgrams <- function(dir, file, ngrams) {
  prefix <- paste(dir, ".", file, sep="")
  preFile = file.path(outputDir, paste(prefix, ".pre", sep=""))

  preProcess(file.path(finalDir, paste(dir, "/", file, sep="")), preFile)

  genNgramsFile(preFile, outputDir, prefix, ngramFiles, ngrams)
}

ngrams <- c(1,2,3)

enNgramsTwitter <- genNgrams("en_US", "en_US.twitter.txt", ngrams)
enNgramsBlogs <- genNgrams("en_US", "en_US.blogs.txt", ngrams)
enNgramsNews <- genNgrams("en_US", "en_US.news.txt", ngrams)

deNgramsTwitter <- genNgrams("de_DE", "de_DE.twitter.txt", ngrams)
deNgramsBlogs <- genNgrams("de_DE", "de_DE.blogs.txt", ngrams)
deNgramsNews <- genNgrams("de_DE", "de_DE.news.txt", ngrams)

fiNgramsTwitter <- genNgrams("fi_FI", "fi_FI.twitter.txt", ngrams)
fiNgramsBlogs <- genNgrams("fi_FI", "fi_FI.blogs.txt", ngrams)
fiNgramsNews <- genNgrams("fi_FI", "fi_FI.news.txt", ngrams)

#ruNgramsTwitter <- genNgrams("ru_RU", "ru_RU.twitter.txt", ngrams)
#ruNgramsBlogs <- genNgrams("ru_RU", "ru_RU.blogs.txt", ngrams)
#ruNgramsNews <- genNgrams("ru_RU", "ru_RU.news.txt", ngrams)


summarise(documentSummary)

for (i in ngrams) {
  sortuniq(file.path(outputDir, paste("en_US.", as.character(i), ".csv", sep="")), c(enNgramsTwitter[i], enNgramsBlogs[i], enNgramsNews[i]))
  sortuniq(file.path(outputDir, paste("de_DE.", as.character(i), ".csv", sep="")), c(deNgramsTwitter[i], deNgramsBlogs[i], deNgramsNews[i]))
  sortuniq(file.path(outputDir, paste("fi_FI.", as.character(i), ".csv", sep="")), c(fiNgramsTwitter[i], fiNgramsBlogs[i], fiNgramsNews[i]))
  #sortuniq(file.path(outputDir, paste("ru_RU.", as.character(i), ".csv", sep="")), c(ruNgramsTwitter[i], ruNgramsBlogs[i], ruNgramsNews[i]))
}
