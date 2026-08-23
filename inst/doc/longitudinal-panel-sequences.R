## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
base <- data.frame(
  participant_id = rep(paste0("p", 1:4), each = 8L),
  occasion = rep(rep(c(1, 2), each = 4L), times = 4L),
  sequence_id = rep(paste0("s", 1:8), each = 4L),
  sequence_order = rep(1:4, times = 8L),
  state = c(
    "A", "B", "C", "D", "A", "B", "D", "D",
    "A", "C", "C", "D", "A", "C", "D", "D",
    "D", "C", "B", "A", "D", "C", "A", "A",
    "D", "B", "B", "A", "D", "B", "A", "A"
  ),
  stringsAsFactors = FALSE
)
head(base)

## ----prepare------------------------------------------------------------------
panel <- prepare_sequence_panel(
  base,
  panel_id_col = "participant_id",
  occasion_col = "occasion"
)
panel$index

## ----summaries----------------------------------------------------------------
panel_summary <- summarise_sequence_panel(panel)
panel_summary$occasions
head(panel_summary$states)

## ----change-------------------------------------------------------------------
changes <- compare_sequence_panel_changes(
  panel,
  method = "levenshtein",
  normalise = "max_length"
)
changes

## ----plot, fig.width=7, fig.height=4------------------------------------------
plot_sequence_panel_changes(changes, metric = "distance", type = "individual")
plot_sequence_panel_changes(changes, metric = "distance", type = "summary")

