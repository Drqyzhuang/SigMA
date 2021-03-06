% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_llh.R
\name{calc_llh}
\alias{calc_llh}
\title{Calculates likelihood of the genome with respect to the available 
signature probability distributions}
\usage{
calc_llh(spectrum, signatures, counts = NULL, normalize = T)
}
\arguments{
\item{spectrum}{is the mutational spectrum}

\item{signatures}{is the reference signature catalog with the 
probability distributions}

\item{counts}{is the number of cases in each cluster that is
represented in the catalog. They are used as weights for each
signature in the catalog}

\item{normalize}{is true by default only for when it is used
together with NNLS in the match_to_catalog function it is not 
normalized here but outside of the function}
}
\description{
Calculates likelihood of the genome with respect to the available 
signature probability distributions
}
