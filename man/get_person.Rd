% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_person}
\alias{get_person}
\title{Get person details}
\usage{
get_person(person_id, token = Sys.getenv("HLIDAC_TOKEN"))
}
\arguments{
\item{person_id}{Person's ID}

\item{token}{Access token}
}
\value{
list with the following elements:
- TitulPred: academic titles written before person's name
- Jmeno: given name
- Prijmeni: surname
- TitulPo: academic titles written after person's name (if applicable)
- Narozeni: date of birth
- NameId: person's id
- Profile: URL of profile at hlidacstatu.cz
- Sponzoring: data.frame with data on sponsorship of political parties
by the person
- Udalosti: events related to the person such as party membership and
running in election, serving in political bodies and relations to private
companies (shareholder, serving on a board)
- SocialniSite: data.frame with data on social media accounts
}
\description{
Get person details
}
\examples{
\dontrun{
get_person("andrej-babis")
}
}
\seealso{
\url{https://www.hlidacstatu.cz/api/v2/swagger/index}

\url{https://www.hlidacstatu.cz/api/v1/doc}

Other Persons: 
\code{\link{get_person_social}()},
\code{\link{search_person}()}
}
\concept{Persons}
