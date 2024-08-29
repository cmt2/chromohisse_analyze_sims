library(gtools)
library(coda)

# get jobs that need to be redone
runs <- 1:100
incomplete_runs <- logical(length(runs))
for(this_run in runs) {
    
    cat(this_run, "\n")
    
    # check for the output file
    this_output <- paste0("output/chromohisse_sim",this_run,".log")
    if ( !file.exists(this_output) ) {
        # no output file, automatically redo
        cat("output absent\n")
        incomplete_runs[this_run] <- TRUE
        next
    }
    
    # otherwise, read output
    samples <- try(read.table(this_output, header = TRUE, sep = "\t", check.names = FALSE, stringsAsFactors = FALSE), silent = TRUE)
    if (inherits(samples, "try-error")) {
        # corrupt output file, automatically redo
        cat("output corrupt\n")
        incomplete_runs[this_run] <- TRUE
        next
    }
        
    # discard some burnin
    samples_burnin <- samples[-c(1:(nrow(samples) * 0.1)),]
    
    # get non-redundant columns
    params_to_diagnose <- c("alpha", "chi", "clado_fission_a", "clado_fission_b", "clado_fusion_a", "clado_fusion_b", "clado_no_change_a", "clado_no_change_b", "delta_a", "delta_b", "gamma_a", "gamma_b", "total_speciation", "turnover")
    samples_burnin <- samples_burnin[,params_to_diagnose]
    
    # compute ESS and overall ESS
    param_ess <- effectiveSize(samples_burnin)
    harmonic_mean_ess <- length(param_ess) / sum(1 / param_ess)
    
    if (harmonic_mean_ess < 500) {
        cat("run failed\n")
        incomplete_runs[this_run] <- TRUE
    } else {
        incomplete_runs[this_run] <- FALSE
    }
    
}


# settings
incomplete_runs <- runs[incomplete_runs]
num_jobs_per_slurm <- 5
num_slurms <- ceiling(length(incomplete_runs) / num_jobs_per_slurm)

# read template
template <- readLines("scripts/slurm_template.sh")

# make folder
dir.create("chromohisse_slurms_rerun", recursive = TRUE, showWarnings = FALSE)

# create job scripts
for (i in 1:num_slurms) {
    
    # copy the template
    this_template <- template
    
    # change jobname
    this_template <- gsub("JOBNAME", paste0("chromohisse_",i), this_template)
    
    # get jobs for this template
    these_jobs <- num_jobs_per_slurm * (i - 1) + 1:num_jobs_per_slurm
    these_jobs <- as.numeric(na.omit(incomplete_runs[these_jobs]))
    
    # edit the template file
    num_nonend_to_retain <- length(these_jobs) - 1
    if (num_nonend_to_retain < 4) {
        matches_to_remove <- paste0("N", (num_nonend_to_retain + 1):4)
        for (j in 1:length(matches_to_remove)) {
            this_template <- this_template[-grep(matches_to_remove[j], this_template)]
        }
    }
    
    
    # change job numbers
    for (j in 1:length(these_jobs)) {
        
        # get old num
        if (j == length(these_jobs)) {
            oldname <- "N5"
        } else {
            oldname <- paste0("N", j)
        }
        
        # get new name
        newname <- as.character(these_jobs[j])
        
        # substitute
        this_template <- gsub(oldname, newname, this_template)
        
    }
    
    # write
    this_fn <- paste0("chromohisse_slurms_rerun/chromohisse_jobs_",i,".sh")
    writeLines(this_template, con = this_fn, sep = "\n")
    
}