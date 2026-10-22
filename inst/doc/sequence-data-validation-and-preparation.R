## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(gp3sequences)

## ----problematic-data---------------------------------------------------------
problem_data <- data.frame(
  sequence_id = c("s2", "s1", "s1", "s1", "s1", "s2", "s2", "s2", "s2"),
  sequence_order = c(2, 2, 1, 2, 3, 1, 2, 3, 4),
  state = factor(
    c("search", "search", "home", "search", NA,
      "home", "home", "product", "other"),
    levels = c("home", "search", "product", "checkout", "other", "unused")
  ),
  duration = c(120, 100, 90, 110, 80, 100, 0, 150, 130),
  participant_id = c("p2", "p1", "p1", "p1", "p1", "p2", "p2", "p2", "p2"),
  group = c("interface_b", "interface_a", "interface_a", "interface_a",
            "interface_a", "interface_b", "interface_b", "interface_b",
            "interface_b"),
  stringsAsFactors = FALSE
)

expected_states <- c("home", "search", "product", "checkout")
problem_data

## ----audit--------------------------------------------------------------------
audit <- audit_sequence_data(
  problem_data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group"),
  expected_states = expected_states
)

audit
as.data.frame(table(audit$severity), stringsAsFactors = FALSE)
as.data.frame(table(audit$issue_code), stringsAsFactors = FALSE)

## ----validation---------------------------------------------------------------
validation <- validate_sequence_data(
  problem_data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group"),
  expected_states = expected_states
)

validation[c("valid", "status", "n_errors", "n_reviews", "n_info")]
validation$mapping

## ----prepare------------------------------------------------------------------
prepared <- prepare_sequence_data(
  problem_data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group"),
  expected_states = expected_states,
  missing_state_policy = "drop",
  duplicate_position_policy = "first",
  repeated_state_policy = "collapse",
  zero_duration_policy = "drop",
  unknown_state_policy = "drop",
  unused_state_levels = "drop"
)

prepared$status
prepared$decisions
prepared$data
prepared$audit

## ----revalidate---------------------------------------------------------------
revalidation <- validate_sequence_data(
  prepared$data,
  sequence_id_col = "sequence_id",
  order_col = "sequence_order",
  state_col = "state",
  duration_col = "duration",
  metadata_cols = c("participant_id", "group"),
  expected_states = expected_states
)

revalidation[c("valid", "status", "n_errors", "n_reviews", "n_info")]
prepared$mapping
prepared$state_levels

