library(gtools)
source("scripts/posterior_boxplot.R")

#######################
# get the true values #
#######################

gamma_a <- 4.6
delta_a <- 4.2

gamma_b <- 0.15
delta_b <- 0.12

alpha <- 0.02

clado_no_change_a <- 0.07
clado_fusion_a    <- 0.5
clado_fission_a   <- 0.3

clado_no_change_b <- 0.9 
clado_fusion_b    <- 0.08
clado_fission_b   <- 0.07

chi <- 0.1

clado_rates <- c(clado_no_change_a, clado_no_change_b, clado_fission_a, clado_fission_b, clado_fusion_a, clado_fusion_b, chi)
total_speciation <- sum(clado_rates)
relative_clado <- clado_rates / total_speciation
turnover <- 0.3

true_values <- c("gamma_a"           = gamma_a,
                 "gamma_b"           = gamma_b,
                 "delta_a"           = delta_a,
                 "delta_b"           = delta_b,
                 "alpha"             = alpha,
                 "clado_no_change_a" = clado_no_change_a,
                 "clado_no_change_b" = clado_no_change_b,
                 "clado_fusion_a"    = clado_fusion_a,
                 "clado_fusion_b"    = clado_fusion_b,
                 "clado_fission_a"   = clado_fission_a,
                 "clado_fission_b"   = clado_fission_b,
                 "chi"               = chi,
                 "total_speciation"  = total_speciation,
                 "turnover"          = turnover)

params <- names(true_values)

####################################
# results for chromoHIsse analyses #
####################################

# get output filenames
chromohisse_output_fn <- mixedsort(list.files("output_low_mu", pattern = "chromohisse", full.names = TRUE))

# get parameters for each output file
chromohisse_results <- do.call(rbind, lapply(chromohisse_output_fn, function(x) {

    cat(x, "\n")
        
    # read samples
    samples <- try(read.table(x, header = TRUE, sep = "\t", stringsAsFactors = FALSE, check.names = FALSE))
    if (inherits(samples, "try-error")) {
        cat("\tfailed to read samples\n")
        return(NULL)
    }
        
    # discard 25% burnin (this is generous)
    samples <- samples[-c(1:(nrow(samples) * 0.25)),]
    
    # get parameters
    param_samples <- samples[, params]

    # make data frame
    res <- data.frame("filename"          = x,
                      "gamma_a"           = I(list(param_samples$gamma_a)),
                      "gamma_b"           = I(list(param_samples$gamma_b)),
                      "delta_a"           = I(list(param_samples$delta_a)),
                      "delta_b"           = I(list(param_samples$delta_b)),
                      "alpha"             = I(list(param_samples$alpha)),
                      "clado_no_change_a" = I(list(param_samples$clado_no_change_a)),
                      "clado_no_change_b" = I(list(param_samples$clado_no_change_b)),
                      "clado_fusion_a"    = I(list(param_samples$clado_fusion_a)),
                      "clado_fusion_b"    = I(list(param_samples$clado_fusion_b)),
                      "clado_fission_a"   = I(list(param_samples$clado_fission_a)),
                      "clado_fission_b"   = I(list(param_samples$clado_fission_b)),
                      "chi"               = I(list(param_samples$chi)),
                      "total_speciation"  = I(list(param_samples$total_speciation)),
                      "turnover"          = I(list(param_samples$turnover)))

    return(res)    
    
}))

# make plots

pdf("figures/chromohisse_boxplots_low_mu.pdf", height = 14, width = 10)

layout_mat <- matrix(1:(length(params) + 4), ncol = 2, byrow = TRUE)
par(oma = c(0,5,3,0) + 0.1, mar = c(0,0,0,0))
layout(layout_mat)

# gamma
boxplot.HPD(chromohisse_results[,"gamma_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,6))
abline(h = true_values["gamma_a"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("gamma", side = 2, line = 3)
mtext("hidden state A", side = 3, line = 1)

boxplot.HPD(chromohisse_results[,"gamma_b"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,6))
abline(h = true_values["gamma_b"], lty = 2, col = "red")
mtext("hidden state B", side = 3, line = 1)

boxplot.HPD(chromohisse_results[,"delta_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,6))
abline(h = true_values["delta_a"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("delta", side = 2, line = 3)

boxplot.HPD(chromohisse_results[,"delta_b"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,6))
abline(h = true_values["delta_b"], lty = 2, col = "red")

boxplot.HPD(chromohisse_results[,"alpha"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,0.5))
abline(h = true_values["alpha"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("alpha", side = 2, line = 3)

plot.new()

boxplot.HPD(chromohisse_results[,"clado_no_change_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,1.5))
abline(h = true_values["clado_no_change_a"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_no_change", side = 2, line = 3)

boxplot.HPD(chromohisse_results[,"clado_no_change_b"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,1.5))
abline(h = true_values["clado_no_change_b"], lty = 2, col = "red")

boxplot.HPD(chromohisse_results[,"clado_fusion_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,1.25))
abline(h = true_values["clado_fusion_a"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_fusion", side = 2, line = 3)

boxplot.HPD(chromohisse_results[,"clado_fusion_b"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,1.25))
abline(h = true_values["clado_fusion_b"], lty = 2, col = "red")

boxplot.HPD(chromohisse_results[,"clado_fission_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,1.25))
abline(h = true_values["clado_fission_a"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_fission", side = 2, line = 3)

boxplot.HPD(chromohisse_results[,"clado_fission_b"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,1.25))
abline(h = true_values["clado_fission_b"], lty = 2, col = "red")

boxplot.HPD(chromohisse_results[,"chi"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,0.5))
abline(h = true_values["chi"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("chi", side = 2, line = 3)
plot.new()

boxplot.HPD(chromohisse_results[,"total_speciation"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(1,3))
abline(h = true_values["total_speciation"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("total_speciation", side = 2, line = 3)
plot.new()

boxplot.HPD(chromohisse_results[,"turnover"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0.0,1.0))
abline(h = true_values["turnover"], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("turnover", side = 2, line = 3)
axis(1, las = 2, lwd = 0, )
plot.new()

dev.off()


pdf("figures/chromohisse_boxplots_low_mu_relative.pdf", height = 14, width = 10)

layout_mat <- matrix(1:(length(params) + 4), ncol = 2, byrow = TRUE)
par(oma = c(0,5,3,0) + 0.1, mar = c(0,0,0,0))
layout(layout_mat)

# gamma
boxplot.HPD(lapply(chromohisse_results[,"gamma_a"], function(x) x / true_values["gamma_a"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 2.5))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("gamma", side = 2, line = 3)
mtext("hidden state A", side = 3, line = 1)

boxplot.HPD(lapply(chromohisse_results[,"gamma_b"], function(x) x / true_values["gamma_b"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 2.5))
abline(h = 1, lty = 2, col = "red")
mtext("hidden state B", side = 3, line = 1)

boxplot.HPD(lapply(chromohisse_results[,"delta_a"], function(x) x / true_values["delta_a"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 2.5))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("delta", side = 2, line = 3)

boxplot.HPD(lapply(chromohisse_results[,"delta_b"], function(x) x / true_values["delta_b"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 2.5))
abline(h = 1, lty = 2, col = "red")

boxplot.HPD(lapply(chromohisse_results[,"alpha"], function(x) x / true_values["alpha"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 10))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("alpha", side = 2, line = 3)

plot.new()

boxplot.HPD(lapply(chromohisse_results[,"clado_no_change_a"], function(x) x / true_values["clado_no_change_a"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 5))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_no_change", side = 2, line = 3)

boxplot.HPD(lapply(chromohisse_results[,"clado_no_change_b"], function(x) x / true_values["clado_no_change_b"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 5))
abline(h = 1, lty = 2, col = "red")

boxplot.HPD(lapply(chromohisse_results[,"clado_fusion_a"], function(x) x / true_values["clado_fusion_a"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 4))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_fusion", side = 2, line = 3)

boxplot.HPD(lapply(chromohisse_results[,"clado_fusion_b"], function(x) x / true_values["clado_fusion_b"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 4))
abline(h = 1, lty = 2, col = "red")

boxplot.HPD(lapply(chromohisse_results[,"clado_fission_a"], function(x) x / true_values["clado_fission_a"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 4))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_fission", side = 2, line = 3)

boxplot.HPD(lapply(chromohisse_results[,"clado_fission_b"], function(x) x / true_values["clado_fission_b"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 4))
abline(h = 1, lty = 2, col = "red")

boxplot.HPD(lapply(chromohisse_results[,"chi"], function(x) x / true_values["chi"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 4))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("chi", side = 2, line = 3)
plot.new()

boxplot.HPD(lapply(chromohisse_results[,"total_speciation"], function(x) x / true_values["total_speciation"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 2))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("total_speciation", side = 2, line = 3)
plot.new()

boxplot.HPD(lapply(chromohisse_results[,"turnover"], function(x) x / true_values["turnover"]), outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 2))
abline(h = 1, lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("turnover", side = 2, line = 3)
axis(1, las = 2, lwd = 0, )
plot.new()

dev.off()


##################################
# results for chromoSSE analyses #
##################################

sse_params <- c("gamma_a", "delta_a", "clado_no_change_a", "clado_fusion_a", "clado_fission_a", "total_speciation", "turnover")

# get output filenames
chromosse_output_fn <- mixedsort(list.files("output_low_mu", pattern = "chromosse", full.names = TRUE))

# get parameters for each output file
chromosse_results <- do.call(rbind, lapply(chromosse_output_fn, function(x) {
    
    cat(x, "\n")
    
    # read samples
    samples <- try(read.table(x, header = TRUE, sep = "\t", stringsAsFactors = FALSE, check.names = FALSE))
    if (inherits(samples, "try-error")) {
        cat("\tfailed to read samples\n")
        return(NULL)
    }
    
    # discard 25% burnin (this is generous)
    samples <- samples[-c(1:(nrow(samples) * 0.25)),]
    
    # get parameters
    param_samples <- samples[, sse_params]
    
    # make data frame
    res <- data.frame("filename"          = x,
                      "gamma_a"           = I(list(param_samples$gamma_a)),
                      "delta_a"           = I(list(param_samples$delta_a)),
                      "clado_no_change_a" = I(list(param_samples$clado_no_change_a)),
                      "clado_fusion_a"    = I(list(param_samples$clado_fusion_a)),
                      "clado_fission_a"   = I(list(param_samples$clado_fission_a)),
                      "total_speciation"  = I(list(param_samples$total_speciation)),
                      "turnover"          = I(list(param_samples$turnover)))
    
    return(res)    
    
}))

# make plots

pdf("figures/chromosse_boxplots_low_mu.pdf", height = 14, width = 10)

layout_mat <- matrix(1:length(sse_params), ncol = 1, byrow = TRUE)
par(oma = c(0,5,3,0) + 0.1, mar = c(0,0,0,0))
layout(layout_mat)

boxplot.HPD(chromosse_results[,"gamma_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,6))
abline(h = true_values[c("gamma_a", "gamma_b")], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("gamma", side = 2, line = 3)

boxplot.HPD(chromosse_results[,"delta_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0,6))
abline(h = true_values[c("delta_a", "delta_b")], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("delta", side = 2, line = 3)

boxplot.HPD(chromosse_results[,"clado_no_change_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 1.25))
abline(h = true_values[c("clado_no_change_a", "clado_no_change_b")], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_no_change", side = 2, line = 3)

boxplot.HPD(chromosse_results[,"clado_fusion_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 0.6))
abline(h = true_values[c("clado_fusion_a", "clado_fusion_b")], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_fusion", side = 2, line = 3)

boxplot.HPD(chromosse_results[,"clado_fission_a"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 0.6))
abline(h = true_values[c("clado_fission_a", "clado_fission_b")], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("clado_fission", side = 2, line = 3)


boxplot.HPD(chromosse_results[,"total_speciation"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 2.5))
abline(h = true_values[c("total_speciation")], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("total_speciation", side = 2, line = 3)

boxplot.HPD(chromosse_results[,"turnover"], outline = FALSE, xaxt = "n", yaxt = "n", ylim = c(0, 1))
abline(h = true_values[c("turnover")], lty = 2, col = "red")
axis(2, las = 2, lwd = 0, lwd.tick = 1)
mtext("turnover", side = 2, line = 3)

dev.off()

























