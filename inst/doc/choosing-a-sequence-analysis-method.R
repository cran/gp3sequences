## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----guide--------------------------------------------------------------------
method_guide <- data.frame(
  question = c(
    "Which exact contiguous patterns recur?",
    "What state is most supported at each aligned position?",
    "How do observed state, transition, or length summaries differ by group?",
    "How dissimilar are complete sequences?",
    "Can a declared distance reveal reproducible descriptive partitions?",
    "Which transitions and contexts organise the observed paths?",
    "Does recent state history improve next-state description?",
    "Can a compact latent categorical model summarise serial dependence?",
    "Is interoperability with a specialist package required?"
  ),
  method = c(
    "Contiguous motifs",
    "Aligned-position consensus",
    "Descriptive group comparison",
    "Sequence distance",
    "Clustering and stability",
    "Transition network",
    "Higher-order transition model",
    "Categorical HMM or mixture HMM",
    "Optional adapter"
  ),
  primary_functions = c(
    "extract_sequence_ngrams(); summarise_sequence_motifs()",
    "create_consensus_sequence(); summarise_consensus_agreement()",
    "compare_sequence_groups()",
    "compute_sequence_distance(); summarise_sequence_distance()",
    "cluster_sequences(); validate_sequence_clusters(); bootstrap_sequence_clusters()",
    "create_transition_network(); summarise_transition_centrality()",
    "fit_higher_order_transition_model(); predict_next_state()",
    "fit_sequence_hmm(); fit_sequence_hmm_mixture(); decode_sequence_states()",
    "as_traminer_sequences(); as_arules_sequences(); as_igraph_transition_network()"
  ),
  stringsAsFactors = FALSE
)

method_guide

