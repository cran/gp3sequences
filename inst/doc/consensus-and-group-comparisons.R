## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
paths <- list(
  s1 = c("home", "search", "product", "checkout"),
  s2 = c("home", "search", "product", "home"),
  s3 = c("home", "category", "product", "checkout"),
  s4 = c("home", "category", "home", "home")
)
sequence_data <- do.call(rbind, lapply(seq_along(paths), function(i) {
  data.frame(
    sequence_id = names(paths)[i],
    sequence_order = seq_along(paths[[i]]),
    state = paths[[i]],
    group = rep(c("interface_a", "interface_b"), each = 2L)[i],
    stringsAsFactors = FALSE
  )
}))
sequence_data

## ----consensus----------------------------------------------------------------
consensus <- create_consensus_sequence(
  sequence_data,
  group_cols = "group",
  tie_method = "first",
  state_levels = c("home", "search", "category", "product", "checkout")
)
consensus
summarise_consensus_agreement(consensus, by = "group")
format_consensus_sequence(consensus, include_agreement = TRUE)

## ----consensus-plot, fig.width=7, fig.height=4--------------------------------
plot_consensus_sequence(consensus, type = "agreement", group = "interface_a")

## ----comparison---------------------------------------------------------------
comparison <- compare_sequence_groups(
  sequence_data,
  group_col = "group"
)
comparison$groups
head(comparison$state_contrasts)
head(comparison$transition_contrasts)
comparison$length_contrasts

## ----comparison-plot, fig.width=7, fig.height=5-------------------------------
plot_sequence_group_comparison(comparison, component = "state", top_n = 5L)

