% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_contract}
\alias{get_contract}
\title{Get contract details}
\usage{
get_contract(id, token = NULL)
}
\arguments{
\item{id}{ID of contract}

\item{token}{Authorization token}
}
\value{
list with data
}
\description{
Get contract details
}
\examples{
\dontrun{
get_contract(id = "1086905")
}
}
\seealso{
\url{https://www.hlidacstatu.cz/swagger/index.html}

\url{https://www.hlidacstatu.cz/api/v1/doc}

\url{https://smlouvy.gov.cz/}
}
