createDir <- function(dataDir) {
  dir.create(dataDir, showWarnings = FALSE)
}

downloadTo <- function(originalDataFile, zipPath) {
  if (!file.exists(zipPath)) {
    print(paste("downloading", originalDataFile))
    download.file(originalDataFile, zipPath)
  }
}

unzipTo <- function(zipPath, dataDir, finalDir) {
  if (!dir.exists(finalDir)) {
    print(paste("unzipping", zipPath))
    unzip(zipPath, exdir=dataDir)
  }
}

