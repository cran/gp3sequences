## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
data <- data.frame(
  sequence_id = rep(paste0("s", 1:8), each = 6L),
  sequence_order = rep(1:6, times = 8L),
  state = c(
    rep(c("A", "B", "B", "C", "D", "D"), 4L),
    rep(c("D", "C", "C", "B", "A", "A"), 4L)
  ),
  stringsAsFactors = FALSE
)
distance <- compute_sequence_distance(data, method = "levenshtein")
clustering <- cluster_sequences(distance, k = 2L, method = "hierarchical")
network <- create_transition_network(data)

## ----index, fig.width=7, fig.height=5-----------------------------------------
plot_sequence_index(data)

## ----distribution, fig.width=7, fig.height=4----------------------------------
plot_sequence_state_distribution(data)

## ----entropy, fig.width=7, fig.height=4---------------------------------------
plot_sequence_entropy(data)

## ----distance, fig.width=6, fig.height=5--------------------------------------
plot_sequence_distance_heatmap(distance)

## ----silhouette, fig.width=7, fig.height=4------------------------------------
plot_sequence_cluster_silhouette(clustering, distance)

## ----network, fig.width=6, fig.height=6---------------------------------------
plot_transition_network(network)

