## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----data---------------------------------------------------------------------
set.seed(1)
participants <- paste0("p", 1:24)
x <- do.call(
  rbind,
  lapply(seq_along(participants), function(i) {
    time <- 1:12
    group <- if (i <= 12L) "control" else "treatment"
    linear <-
      -0.4 +
      0.06 * time +
      0.35 * (group == "treatment") * sin(time / 3)

    data.frame(
      participant_id = participants[i],
      sequence_id = participants[i],
      sequence_order = time,
      group = group,
      state = ifelse(
        stats::runif(length(time)) < stats::plogis(linear),
        "A",
        "B"
      ),
      stringsAsFactors = FALSE
    )
  })
)

## ----fit----------------------------------------------------------------------
if (requireNamespace("mgcv", quietly = TRUE)) {
  model <- fit_time_varying_sequence_model(
    x,
    group_col = "group",
    participant_id_col = "participant_id",
    target_state = "A",
    k = 5L
  )
  model_summary <- summarise_time_varying_sequence_model(model)
  model_summary$metadata
  model_summary$parametric_terms
  model_summary$smooth_terms
}

## ----predict------------------------------------------------------------------
if (requireNamespace("mgcv", quietly = TRUE)) {
  predictions <- predict_time_varying_sequence_model(
    model,
    time = seq(1, 12, length.out = 60L),
    level = 0.95
  )
  head(predictions)
}

## ----plot, fig.width=7, fig.height=4------------------------------------------
if (requireNamespace("mgcv", quietly = TRUE)) {
  plot_time_varying_sequence_model(model)
}

