## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----data---------------------------------------------------------------------
library(gp3sequences)

sequence_data <- data.frame(
  sequence = c(
    rep("s1", 5L),
    rep("s2", 4L),
    rep("s3", 3L)
  ),
  order = c(1:5, 1:4, 1:3),
  state = c(
    "A", "B", "A", "B", "C",
    "A", "B", "C", "B",
    "B", "A", "B"
  ),
  group = c(
    rep("g1", 5L),
    rep("g1", 4L),
    rep("g2", 3L)
  ),
  stringsAsFactors = FALSE
)

sequence_data

## ----extract------------------------------------------------------------------
extracted <- extract_sequence_ngrams(
  sequence_data,
  sequence_id_col = "sequence",
  order_col = "order",
  state_col = "state",
  metadata_cols = "group",
  min_length = 2L,
  max_length = 3L,
  overlap = "allow"
)

head(extracted$occurrences)

## ----summarise-filter-format--------------------------------------------------
motif_summary <- summarise_sequence_motifs(extracted)

motif_filter <- filter_sequence_motifs(
  motif_summary,
  min_occurrences = 2L,
  min_sequences = 2L,
  min_prevalence = 0.50,
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

## ----position-summary---------------------------------------------------------
position_summary <- summarise_sequence_motif_positions(
  extracted,
  position = "centre",
  scale = "relative",
  by = "group"
)

position_summary$summary

## ----position-format----------------------------------------------------------
position_table <- format_sequence_motif_positions(
  position_summary,
  digits = 1L,
  position_units = "percent",
  include_rank = TRUE
)

position_table$table

## ----motif-plot, fig.cap="Sequence prevalence for the most frequent contiguous motifs."----
plotted_motifs <- plot_sequence_motifs(
  motif_summary,
  metric = "sequence_prevalence",
  top_n = 8L,
  motif_lengths = c(2L, 3L),
  ties = "include",
  horizontal = TRUE
)

plotted_motifs[
  c("plot_rank", "motif", "motif_length", "plot_value")
]

## ----position-strip, fig.cap="Relative centre positions of selected motif occurrences."----
strip_data <- plot_sequence_motif_positions(
  extracted,
  position = "centre",
  scale = "relative",
  top_n = 5L,
  display = "strip"
)

head(
  strip_data[
    c(
      "sequence_id",
      "motif",
      "position_value",
      "plot_rank"
    )
  ]
)

## ----position-distribution, fig.cap="Distributions of relative motif centre positions."----
plot_sequence_motif_positions(
  extracted,
  position = "centre",
  scale = "relative",
  top_n = 5L,
  display = "distribution"
)

