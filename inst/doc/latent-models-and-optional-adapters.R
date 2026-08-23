## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
paths <- list(
  s1 = c("A", "A", "B", "B", "C"),
  s2 = c("A", "B", "B", "C", "C"),
  s3 = c("A", "A", "B", "C", "C"),
  s4 = c("C", "C", "B", "B", "A"),
  s5 = c("C", "B", "B", "A", "A"),
  s6 = c("C", "C", "B", "A", "A")
)
sequence_data <- do.call(rbind, lapply(seq_along(paths), function(i) {
  data.frame(sequence_id = names(paths)[i],
             sequence_order = seq_along(paths[[i]]),
             state = paths[[i]], stringsAsFactors = FALSE)
}))

## ----hmm----------------------------------------------------------------------
hmm <- fit_sequence_hmm(
  sequence_data,
  n_states = 2L,
  max_iter = 60L,
  seed = 10L
)
summarise_sequence_hmm(hmm)$fit
head(decode_sequence_states(hmm, method = "viterbi"))

one_state <- fit_sequence_hmm(
  sequence_data,
  n_states = 1L,
  max_iter = 30L,
  seed = 10L
)
compare_sequence_hmms(one_state = one_state, two_state = hmm)

## ----mixture------------------------------------------------------------------
mixture <- fit_sequence_hmm_mixture(
  sequence_data,
  n_components = 2L,
  n_states = 2L,
  max_iter = 40L,
  inner_initial_iter = 5L,
  seed = 12L
)
summarise_sequence_hmm(mixture)$mixture
mixture$responsibilities

## ----adapters-----------------------------------------------------------------
grp_input <- as_grpstring_data(sequence_data)
grp_input$key
grp_input$strings

if (requireNamespace("TraMineR", quietly = TRUE)) {
  traminer_sequences <- as_traminer_sequences(sequence_data)
  class(traminer_sequences)
}

if (requireNamespace("TraMineR", quietly = TRUE) &&
    requireNamespace("seqHMM", quietly = TRUE)) {
  seqhmm_sequences <- as_seqhmm_sequences(sequence_data)
  class(seqhmm_sequences)
}

if (requireNamespace("arules", quietly = TRUE) &&
    requireNamespace("arulesSequences", quietly = TRUE)) {
  cspade_input <- as_arules_sequences(sequence_data)
  arules::transactionInfo(cspade_input)
}

network <- create_transition_network(sequence_data)
if (requireNamespace("igraph", quietly = TRUE)) {
  graph <- as_igraph_transition_network(network)
  class(graph)
}

renamed <- sequence_data
names(renamed)[names(renamed) == "sequence_order"] <- "position"
names(renamed)[names(renamed) == "state"] <- "aoi_label"
prepared <- prepare_gp3tools_sequences(renamed)
prepared$status

