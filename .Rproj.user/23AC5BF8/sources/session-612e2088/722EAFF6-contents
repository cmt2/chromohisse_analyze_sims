# settings
num_jobs_per_slurm <- 5
jobs <- 1:100
num_slurms <- length(jobs) / num_jobs_per_slurm

# read template
template <- readLines("scripts/slurm_template.sh")

# create job scripts
for (i in 1:num_slurms) {

    # copy the template
    this_template <- template
    
    # change jobname
    this_template <- gsub("JOBNAME", paste0("chromohisse_",i), this_template)
    
    # change job numbers
    for (j in 1:num_jobs_per_slurm) {
        
        # get old num
        oldname <- paste0("N", j)
        
        # get new name
        newname <- paste(j + (i - 1) * num_jobs_per_slurm)
        
        # substitute
        this_template <- gsub(oldname, newname, this_template)
        
    }
    
    # write
    this_fn <- paste0("chromohisse_slurms/chromohisse_jobs_",i,".sh")
    writeLines(this_template, con = this_fn, sep = "\n")
       
}