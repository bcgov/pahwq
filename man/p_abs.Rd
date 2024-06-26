% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ptlm.R
\name{p_abs}
\alias{p_abs}
\title{Calculate the total light absorption of a PAH using the results of the TUV model}
\usage{
p_abs(tuv_results, pah, time_multiplier = 2)
}
\arguments{
\item{tuv_results}{data.frame of TUV results}

\item{pah}{name of PAH to calculate light absorption for}

\item{time_multiplier}{multiplier to get the total exposure time. I.e., if
the tuv_results contains 24 hours of data, and you need a 48h exposure, the
multiplier would be 2. (this is the default)}
}
\value{
The value of \code{Pabs} for the TUV results.
}
\description{
Calculate the total light absorption of a PAH using the results of the TUV model
}
