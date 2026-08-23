## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
paths <- list(
  s1 = c("A", "B", "C", "D"),
  s2 = c("A", "B", "C", "C"),
  s3 = c("A", "C", "C", "D"),
  s4 = c("D", "C", "B", "A"),
  s5 = c("D", "C", "A", "A"),
  s6 = c("D", "B", "B", "A")
)
sequence_data <- do.call(rbind, lapply(seq_along(paths), function(i) {
  data.frame(sequence_id = names(paths)[i],
             sequence_order = seq_along(paths[[i]]),
             state = paths[[i]], stringsAsFactors = FALSE)
}))

## ----distances----------------------------------------------------------------
levenshtein <- compute_sequence_distance(sequence_data, method = "levenshtein")
lcs <- compute_sequence_distance(sequence_data, method = "lcs")
om <- compute_sequence_distance(
  sequence_data,
  method = "optimal_matching",
  indel_cost = 1,
  substitution_cost = 2,
  normalise = "max_length"
)
transition <- compute_sequence_distance(sequence_data, method = "transition")
summarise_sequence_distance(lcs)$overall

## ----clustering---------------------------------------------------------------
fit <- cluster_sequences(lcs, k = 2L, method = "hierarchical", linkage = "average")
fit$assignments
validate_sequence_clusters(fit)$overall
extract_representative_sequences(fit)

## ----stability----------------------------------------------------------------
stability <- bootstrap_sequence_clusters(
  lcs,
  k = 2L,
  n_boot = 20L,
  sample_fraction = 0.8,
  seed = 100L
)
summarise_sequence_cluster_stability(stability)$overall

## ----ensemble-----------------------------------------------------------------
transition_fit <- cluster_sequences(
  transition,
  k = 2L,
  method = "hierarchical",
  linkage = "average"
)
ensemble <- create_sequence_cluster_ensemble(
  fit,
  transition_fit,
  k = 2L
)
ensemble$assignments
ensemble$coassociation

## ----optional-cluster---------------------------------------------------------
if (requireNamespace("cluster", quietly = TRUE)) {
  pam_fit <- cluster_sequences(lcs, k = 2L, method = "pam", seed = 11L)
  clara_fit <- cluster_sequences(
    lcs,
    k = 2L,
    method = "clara",
    seed = 11L,
    samples = 5L,
    sampsize = 5L
  )
  list(pam = pam_fit$assignments, clara = clara_fit$assignments)
}

