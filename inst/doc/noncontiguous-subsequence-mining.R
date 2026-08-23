## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
sequences <- data.frame(
  sequence_id = rep(paste0("s", 1:6), each = 5L),
  sequence_order = rep(1:5, times = 6L),
  state = c(
    "A", "B", "C", "D", "E",
    "A", "C", "B", "D", "E",
    "A", "B", "D", "C", "E",
    "E", "D", "C", "B", "A",
    "E", "C", "D", "B", "A",
    "E", "D", "B", "C", "A"
  ),
  group = rep(rep(c("forward", "reverse"), each = 3L), each = 5L),
  stringsAsFactors = FALSE
)

## ----extract------------------------------------------------------------------
occurrences <- extract_sequence_subsequences(
  sequences,
  metadata_cols = "group",
  min_length = 2L,
  max_length = 3L,
  max_gap = 2L,
  max_span = 4L,
  repeated_state_policy = "preserve"
)
head(occurrences)
attributes(occurrences)[c("n_sequences", "settings")]

## ----summary------------------------------------------------------------------
subsequence_summary <- summarise_sequence_subsequences(occurrences)
head(subsequence_summary, 10L)

frequent <- filter_sequence_subsequences(
  subsequence_summary,
  min_sequences = 2L,
  min_prevalence = 0.25,
  top_n = 12L
)
frequent

## ----compare------------------------------------------------------------------
comparison <- compare_sequence_subsequences(
  occurrences,
  group_col = "group",
  p_adjust = "holm"
)
head(comparison, 10L)

## ----plot, fig.width=7, fig.height=5------------------------------------------
plot_sequence_subsequences(frequent, metric = "sequence_prevalence")

