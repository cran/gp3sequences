## ----transition-audit-setup---------------------------------------------------
source(system.file("research", "october_2026_transition_unit_audit.R",
                   package = "gp3sequences"), local = TRUE)
example_data <- gp3sequences_october_transition_data()
audit <- gp3sequences_october_transition_audit(example_data)
stopifnot(nrow(audit$participant) == 16L,
          nrow(example_data) == 340L)
audit$summary

## ----transition-audit-figure, fig.width=9, fig.height=4, fig.cap="Original R-generated synthetic figures. The left panel compares transition-weighted and participant-equal estimands; the right panel shows why unequal observation counts can change their interpretation."----
gp3sequences_october_transition_plot(audit)

## ----transition-participants-figure, fig.width=9, fig.height=4, fig.cap="Descriptive participant-level rates from the single synthetic generating dataset; bars are not confidence intervals or posterior estimates."----
person <- audit$participant
person <- person[order(person$participant_rate), , drop = FALSE]
graphics::barplot(person$participant_rate,
                  names.arg = person$participant_id, las = 2,
                  ylim = c(0, 1), col = "#B4CEDF",
                  border = "#496779",
                  ylab = "Target-transition fraction",
                  main = "Participant-specific transition rates")
graphics::abline(h = audit$summary$estimate[2L], lty = 2,
                 col = "#C05B43", lwd = 2)

