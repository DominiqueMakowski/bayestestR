#' Area under the Curve (AUC)
#'
#' Based on the DescTools \code{AUC} function. It can calculate the area under the curve with a naive algorithm or a more elaborated spline approach. The curve must be given by vectors of xy-coordinates. This function can handle unsorted x values (by sorting x) and ties for the x values (by ignoring duplicates).
#'
#' @param x Vector of x values.
#' @param y Vector of y values.
#' @param method Method to compute the Area Under the Curve (AUC). Can be \code{"trapezoid"} (default), \code{"step"} or \code{"spline"}. If "trapezoid", the curve is formed by connecting all points by a direct line (composite trapezoid rule). If "step" is chosen then a stepwise connection of two points is used. For calculating the area under a spline interpolation the splinefun function is used in combination with integrate.
#' @param ... Arguments passed to or from other methods.
#'
#'
#' @examples
#' library(bayestestR)
#' posterior <- distribution_normal(1000)
#'
#' dens <- estimate_density(posterior)
#' dens <- dens[dens$x > 0, ]
#' x <- dens$x
#' y <- dens$y
#'
#' area_under_curve(x, y, method = "trapezoid")
#' area_under_curve(x, y, method = "step")
#' area_under_curve(x, y, method = "spline")
#' @importFrom stats integrate splinefun
#' @seealso DescTools
#' @export
area_under_curve <- function(x, y, method = c("trapezoid", "step", "spline"), ...) {

  # Stolen from DescTools: https://github.com/cran/DescTools/blob/master/R/StatsAndCIs.r

  if (length(x) != length(y)) {
    stop("length x must equal length y")
  }

  idx <- order(x)
  x <- x[idx]
  y <- y[idx]

  switch(match.arg(arg = method, choices = c("trapezoid", "step", "spline")),
    "trapezoid" = sum((rowMeans(cbind(y[-length(y)], y[-1]))) * (x[-1] - x[-length(x)])),
    "step" = sum(y[-length(y)] * (x[-1] - x[-length(x)])),
    "spline" = stats::integrate(stats::splinefun(x, y, method = "natural"), lower = min(x), upper = max(x))$value
  )
}

#' @rdname area_under_curve
#' @export
auc <- area_under_curve
