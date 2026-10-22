## ----gp3sequences-paired, fig.width=7.5, fig.height=4.5-----------------------
set.seed(20261009)
n <- 30L
latent <- stats::rbeta(n, 8, 12)
control <- stats::rbinom(n, size = 40, prob = latent) / 40
treatment <- stats::rbinom(
  n, size = 40, prob = pmin(latent + .10, .95)
) / 40
graphics::plot(
  NA, xlim = c(.8, 2.2), ylim = c(0, 1), xaxt = "n",
  xlab = "", ylab = "Synthetic AOI-to-AOI transition proportion",
  main = "Paired subject summaries; 40 transitions per condition"
)
graphics::axis(1, at = 1:2, labels = c("Control", "Treatment"))
graphics::segments(
  1, control, 2, treatment,
  col = grDevices::adjustcolor("#608B9A", alpha.f = .4)
)
graphics::points(rep(1, n), control, pch = 19, col = "#387C88")
graphics::points(rep(2, n), treatment, pch = 19, col = "#9265AA")

## ----gp3sequences-effect, fig.width=7.5, fig.height=4.5-----------------------
effect <- treatment - control
draws <- replicate(
  2000L, mean(sample(effect, size = length(effect), replace = TRUE))
)
interval <- stats::quantile(draws, c(.025, .975))
graphics::hist(
  draws, breaks = 25, col = "#8EB9C1", border = "white",
  main = "Bootstrap of participant-level transition effect",
  xlab = "Average difference in transition proportion"
)
graphics::abline(v = 0, lty = 3)
graphics::abline(v = mean(effect), col = "#245E69", lwd = 2)
graphics::abline(v = interval, col = "#B57D61", lty = 2, lwd = 2)

