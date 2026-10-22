## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
paths <- list(
  s1 = c("A", "A", "B", "B", "C"),
  s2 = c("A", "B", "B", "C", "C"),
  s3 = c("C", "C", "B", "B", "A"),
  s4 = c("C", "B", "B", "A", "A"),
  s5 = c("A", "A", "B", "C", "C"),
  s6 = c("C", "C", "B", "A", "A")
)
data <- do.call(rbind, lapply(seq_along(paths), function(i) {
  data.frame(
    sequence_id = names(paths)[i],
    sequence_order = seq_along(paths[[i]]),
    state = paths[[i]],
    context = c("x", "x", "y", "y", "z"),
    condition = as.integer(i > 3L),
    stringsAsFactors = FALSE
  )
}))

## ----multichannel-------------------------------------------------------------
multi <- fit_multichannel_sequence_hmm(
  data,
  n_states = 2L,
  channel_cols = c("state", "context"),
  max_iter = 15L,
  seed = 2L
)
summarise_multichannel_sequence_hmm(multi)$fit
head(decode_multichannel_sequence_states(multi))

## ----emission-plot, fig.width=7, fig.height=4---------------------------------
plot_multichannel_sequence_hmm(multi, channel = "state")

## ----covariate----------------------------------------------------------------
covariate <- fit_covariate_sequence_hmm(
  data,
  n_states = 2L,
  initial_covariate_cols = "condition",
  transition_covariate_cols = "condition",
  max_iter = 10L,
  inner_maxit = 30L,
  seed = 3L
)
summarise_covariate_sequence_hmm(covariate)$fit
predict_covariate_transition_probabilities(
  covariate,
  data.frame(condition = c(0, 1))
)
head(decode_covariate_sequence_states(covariate))

