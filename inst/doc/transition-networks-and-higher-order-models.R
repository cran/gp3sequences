## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
paths <- list(
  s1 = c("home", "search", "product", "checkout"),
  s2 = c("home", "search", "product", "home"),
  s3 = c("home", "category", "product", "checkout"),
  s4 = c("home", "category", "home", "search")
)
sequence_data <- do.call(rbind, lapply(seq_along(paths), function(i) {
  data.frame(sequence_id = names(paths)[i],
             sequence_order = seq_along(paths[[i]]),
             state = paths[[i]], stringsAsFactors = FALSE)
}))

## ----network------------------------------------------------------------------
network <- create_transition_network(
  sequence_data,
  normalise = "from",
  include_self = TRUE
)
network
summarise_transition_centrality(network)
detect_transition_communities(network)

## ----higher-order-------------------------------------------------------------
model <- fit_higher_order_transition_model(
  sequence_data,
  order = 2L,
  smoothing = 0.5,
  backoff = TRUE
)
predict_next_state(model, c("home", "search"))
predict_next_state(model, c("unseen"))

## ----bootstrap----------------------------------------------------------------
boot <- bootstrap_transition_network(
  sequence_data,
  n_boot = 20L,
  level = 0.95,
  seed = 8L
)
head(boot)

