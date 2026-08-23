## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)
library(gp3sequences)

## ----data---------------------------------------------------------------------
paths <- list(
  s1 = c("home", "search", "product", "cart", "checkout"),
  s2 = c("home", "search", "product", "cart", "home"),
  s3 = c("home", "category", "product", "cart", "checkout"),
  s4 = c("home", "category", "product", "search", "checkout"),
  s5 = c("home", "category", "search", "product", "checkout"),
  s6 = c("home", "search", "category", "product", "home"),
  s7 = c("home", "category", "product", "cart", "home"),
  s8 = c("home", "search", "product", "checkout", "home")
)

raw_sequences <- do.call(
  rbind,
  lapply(seq_along(paths), function(i) {
    data.frame(
      sequence_id = names(paths)[i],
      sequence_order = seq_along(paths[[i]]),
      state = paths[[i]],
      duration = 80 + 10 * seq_along(paths[[i]]) + i,
      participant_id = sprintf("p%02d", i),
      group = if (i <= 4L) "interface_a" else "interface_b",
      stringsAsFactors = FALSE
    )
  })
)

raw_sequences

## ----contract-----------------------------------------------------------------
audit <- audit_sequence_data(
  raw_sequences,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group")
)

validation <- validate_sequence_data(
  raw_sequences,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group")
)

prepared <- prepare_sequence_data(
  raw_sequences,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group"),
  missing_state_policy = "error",
  duplicate_position_policy = "error",
  repeated_state_policy = "preserve",
  zero_duration_policy = "preserve",
  unknown_state_policy = "preserve",
  unused_state_levels = "preserve"
)

validation$status
prepared$status
prepared$mapping
prepared$decisions
head(prepared$data)

## ----summaries----------------------------------------------------------------
encoded <- encode_sequence_data(
  prepared$data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group")
)

state_summary <- summarise_sequence_states(
  prepared$data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group")
)

transition_summary <- summarise_sequence_transitions(
  prepared$data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  metadata_cols = c("participant_id", "group"),
  include_self = TRUE
)

paths_table <- format_sequence_paths(
  prepared$data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  metadata_cols = c("participant_id", "group")
)

encoded$dictionary
state_summary$overall
head(transition_summary$overall)
paths_table$paths

## ----motifs-------------------------------------------------------------------
motif_occurrences <- extract_sequence_ngrams(
  prepared$data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  metadata_cols = "group",
  min_length = 2L,
  max_length = 3L,
  overlap = "allow"
)

motif_summary <- summarise_sequence_motifs(motif_occurrences)

motif_filter <- filter_sequence_motifs(
  motif_summary,
  min_occurrences = 2L,
  min_sequences = 2L,
  min_prevalence = 0.20,
  motif_lengths = c(2L, 3L),
  top_n = 10L,
  rank_by = "sequence_prevalence",
  ties = "include"
)

motif_table <- format_sequence_motifs(
  motif_filter,
  prevalence = "percent",
  digits = 1L
)

motif_table$table

## ----distance-clustering------------------------------------------------------
lcs_distance <- compute_sequence_distance(
  prepared$data,
  method = "lcs",
  normalise = "max_length"
)

cluster_fit <- cluster_sequences(
  lcs_distance,
  k = 2L,
  method = "hierarchical",
  linkage = "average"
)

cluster_validation <- validate_sequence_clusters(cluster_fit)
representatives <- extract_representative_sequences(cluster_fit)

summarise_sequence_distance(lcs_distance)$overall
cluster_fit$assignments
cluster_validation$overall
representatives

## ----consensus-groups---------------------------------------------------------
consensus <- create_consensus_sequence(
  prepared$data,
  group_cols = "group",
  tie_method = "first",
  state_levels = encoded$dictionary$state
)

group_comparison <- compare_sequence_groups(
  prepared$data,
  group_col = "group"
)

summarise_consensus_agreement(consensus, by = "group")
format_consensus_sequence(consensus, include_agreement = TRUE)
head(group_comparison$state_contrasts)
head(group_comparison$transition_contrasts)
group_comparison$length_contrasts

## ----networks-----------------------------------------------------------------
network <- create_transition_network(
  prepared$data,
  normalise = "from",
  include_self = TRUE
)

network
summarise_transition_centrality(network)
detect_transition_communities(network)

