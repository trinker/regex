#' A range or char_class of characters.
#' 
#' Match a range or char_class of characters.
#' @param x A character vector.
#' @return A character vector representing part or all of a regular expression.
#' @references \url{http://www.regular-expressions.info/charclass.html}
#' @examples
#' char_range("e", "t")
#' char_range(3, 5)
#' char_class(LOWER)
#' negated_char_class(LOWER)
#' @export
char_class <- function(x)
{
  regex("[", x, "]")
}

#' @rdname char_class
#' @export
negated_char_class <- function(x)
{
  regex("[^", x, "]")
}

#' @rdname char_class
#' @export
negate_and_group <- function(x)
{
  .Deprecated("negated_char_class")
  negated_char_class(x)
}

#' Repeat values
#' 
#' Match repeated values.
#' @param x A character vector.
#' @param lo A non-negative integer. Minimum number of repeats, when grouped.
#' @param hi positive integer. Maximum number of repeats, when grouped.
#' @return A character vector representing part or all of a regular expression.
#' @references \url{http://www.regular-expressions.info/repeat.html}
#' @examples
#' x <- char_class(graph())
#' optional(x)
#' zero_or_more(x)
#' repeated(x, 0, Inf) # same
#' one_or_more(x)
#' repeated(x, 1, Inf) # same
#' repeated(x, 3)
#' repeated(x, 3, 5)
#' @export
repeated <- function(x, lo, hi)
{
  lo <- as.integer(lo)
  if(is.na(lo))
  {
    stop("lo is missing.")
  }
  if(lo < 0)
  {
    stop("lo must be non-negative.")
  }
  if(missing(hi) || !is.finite(hi))
  {
    if(lo == 0)
    {
      return(zero_or_more(x))
    }
    if(lo == 1)
    {
      return(one_or_more(x))
    }
    return(regex(x, "{", lo, "}"))
  }
  hi <- as.integer(hi)
  
  if(is.na(hi))
  {
    stop("hi is missing.")
  }
  if(hi <= lo)
  {
    stop("hi must be greater than lo.")
  }
  if(hi == 1)
  {
    # Implicitly lo == 0
    return(optional(x))
  }
  regex(x, "{", lo, ",", hi, "}")
}

#' @rdname repeated
#' @export
optional <- function(x)
{
  regex(x, "?")
}

#' @rdname repeated
#' @export
lazy <- optional

#' @rdname repeated
#' @export
zero_or_more <- function(x)
{
  regex(x, "*")
}

#' @rdname repeated
#' @export
one_or_more <- function(x)
{
  regex(x, "+")
}

#' Engine for grouping and repeating classes
#' 
#' An engine for the class functions that implicited calls \code{char_class} and
#' \code{repeated} for certain input combinations.
#' @param x A string.
#' @param lo A non-negative integer. Minimum number of repeats, when grouped.
#' @param hi positive integer. Maximum number of repeats, when grouped.
#' @param char_class \code{TRUE} or \code{FALSE}. Should the class be grouped?
#' @return A character vector representing part or all of a regular expression.
repeat_in_class <- function(x, lo, hi, char_class)
{
  if(char_class)
  {
    x <- char_class(x)
    if(!missing(lo))
    {
      x <- repeated(x, lo, hi)
    }
  }
  x
}
