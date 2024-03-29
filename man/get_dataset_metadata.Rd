% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_dataset_metadata}
\alias{get_dataset_metadata}
\title{Get dataset's metadata}
\usage{
get_dataset_metadata(dataset_id, token = Sys.getenv("HLIDAC_TOKEN"))
}
\arguments{
\item{dataset_id}{ID of dataset}

\item{token}{Authorization token}
}
\value{
a list containing metadata related to the specified dataset
}
\description{
Get metadata related to specified dataset.
}
\examples{
\dontrun{
get_dataset_metadata("ministri")
}
}
\seealso{
\url{https://www.hlidacstatu.cz/swagger/index.html}

\url{https://www.hlidacstatu.cz/api/v1/doc}

Other Datasets: 
\code{\link{get_dataset_data}()},
\code{\link{get_dataset_record_detail}()},
\code{\link{get_datasets}()}
}
\concept{Datasets}
