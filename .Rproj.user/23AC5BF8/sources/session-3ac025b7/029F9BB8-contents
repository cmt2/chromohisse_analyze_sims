# find all the data.tsvs
data_fns <- list.files("data_low_mu", pattern = "[0-9].tsv", full.names = TRUE)

for(i in 1:length(data_fns)) {
    
    # get the filename
    this_fn <- data_fns[i]
    
    # read the file
    this_data <- read.table(this_fn, header = FALSE, sep = "\t")
    
    # edit data
    this_char <- this_data[,2]
    this_char <- gsub("(", "", this_char, fixed = TRUE)
    this_char <- gsub(")", "", this_char, fixed = TRUE)
    this_char <- sapply(strsplit(this_char, " "), head, n = 1)
    
    # record new dataset
    this_data[,2] <- this_char
    
    # make new file
    new_fn <- gsub(".tsv", "_sse.tsv", this_fn, fixed = TRUE)
    write.table(this_data, file = new_fn, sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE)
    
}