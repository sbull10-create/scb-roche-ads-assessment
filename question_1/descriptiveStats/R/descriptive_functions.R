#' Calculate Arithmetic Mean
#'
#' Computes the arithmetic mean of a numeric vector.
#' Missing values (NA) are removed before calculation.
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the mean.
#'
#' @examples
#' calc_mean(c(1, 2, 3, 4))
#' calc_mean(c(1, 2, NA, 4))
#'
#' @export
calc_mean <- function(x) {
  
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.", call. = FALSE)
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) {
    stop("Input vector contains no valid numeric values.", call. = FALSE)
  }
  
  mean(x)
}
#' Calculate Median
#'
#' Computes the median of a numeric vector.
#' Missing values (NA) are removed before calculation.
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the median.
#'
#' @examples
#' calc_median(c(1, 2, 3, 4))
#' calc_median(c(1, 2, NA, 4))
#'
#' @export
calc_median <- function(x) {
  
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.", call. = FALSE)
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) {
    stop("Input vector contains no valid numeric values.", call. = FALSE)
  }
  
  median(x)
}
#' Calculate Mode
#'
#' Computes the mode of a numeric vector.
#' Missing values (NA) are removed before calculation.
#' Where Mode is bimodal the first occurring value will be returned
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the mode.
#'
#' @examples
#' calc_mode(c(1, 2, 3, 4))
#' calc_mode(c(1, 2, NA, 4))
#'
#' @export
calc_mode <- function(x) {
  
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.", call. = FALSE)
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) {
    stop("Input vector contains no valid numeric values.", call. = FALSE)
  }
  
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
#' Calculate First Quartile
#'
#' Computes the First Quartile of a numeric vector.
#' Missing values (NA) are removed before calculation.
#' Uses Tukey's Quartile Method
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the First Quartile.
#'
#' @examples
#' calc_q1(c(1, 2, 3, 4))
#' calc_q1(c(1, 2, NA, 4))
#'
#' @export
calc_q1 <- function(x) {
  
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.", call. = FALSE)
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) {
    stop("Input vector contains no valid numeric values.", call. = FALSE)
  }
  
  as.numeric(quantile(x, probs = 0.25, type = 2))
}
#' Calculate Third Quartile
#'
#' Computes the Third Quartile of a numeric vector.
#' Missing values (NA) are removed before calculation.
#' Uses Tukey's Quartile Method
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the Third Quartile.
#'
#' @examples
#' calc_q3(c(1, 2, 3, 4))
#' calc_q3(c(1, 2, NA, 4))
#'
#' @export
calc_q3 <- function(x) {
  
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.", call. = FALSE)
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) {
    stop("Input vector contains no valid numeric values.", call. = FALSE)
  }
  
  as.numeric(quantile(x, probs = 0.75, type = 2))
}
#' Calculate Interquartile Range
#'
#' Computes the Interquartile Range of a numeric vector.
#' Missing values (NA) are removed before calculation.
#'
#' @param x A numeric vector.
#'
#' @return A single numeric value representing the Interquartile Range.
#'
#' @examples
#' calc_iqr(c(1, 2, 3, 4))
#' calc_iqr(c(1, 2, NA, 4))
#'
#' @export
calc_iqr <- function(x) {
  
  if (!is.numeric(x)) {
    stop("Input must be a numeric vector.", call. = FALSE)
  }
  
  x <- x[!is.na(x)]
  
  if (length(x) == 0) {
    stop("Input vector contains no valid numeric values.", call. = FALSE)
  }
  
  calc_q3(x) - calc_q1(x)
}