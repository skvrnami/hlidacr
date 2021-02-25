#' Get list of datasets
#'
#' Get list of datasets available via Hlídač státu API
#'
#' @param token Authorization token
#'
#' @return Response from the server containing list of all datasets available.
#' The list contains 3 elements:
#' - Total: Total number of datasets available (integer)
#' - Page: Page of the result (integer)
#' - Results: Data.frame with data concerning the datasets
#' @export
#' @family Datasets
#' @examples
#' \dontrun{
#' get_datasets(token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_datasets <- function(token = NULL) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    "https://www.hlidacstatu.cz/Api/v2/datasety/",
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get dataset's metadata
#'
#' Get metadata related to specified dataset.
#'
#' @param dataset_id ID of dataset
#' @param token Authorization token
#'
#' @return List containing metadata related to the specified dataset
#' @export
#' @family Datasets
#' @examples
#' \dontrun{
#' get_dataset_metadata("ministri", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_dataset_metadata <- function(dataset_id, token = NULL) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get data from the dataset
#'
#' @param dataset_id ID of dataset
#' @param token Authorization token
#' @param query Search query
#' @param page Number of page
#' @param sort Sort by column
#' @param desc Descending or ascending sorting
#'
#' @return list containing 3 elements:
#' - Total: Total number of datasets available (integer)
#' - Page: Page of the result (integer), equal to the `page` argument of the function
#' - Results: Data.frame with data, columns vary depending on the dataset
#' @export
#' @family Datasets
#' @examples
#' \dontrun{
#' get_dataset_data("ministri", token = "XXXX")
#' get_dataset_data("ministri", query = "Zeman", page = 1, token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_dataset_data <- function(dataset_id, token = NULL, query = NULL, page = 1, sort = NULL, desc = NULL) {
  check_token(token)
  check_connection()

  if (!is.null(query)) {
    query <- urltools::url_encode(query)
    query <- glue::glue("dotaz={query}")
  }

  if (!is.null(page)) {
    page <- glue::glue("strana={page}")
  }

  if (!is.null(sort)) {
    sort <- glue::glue("sort={sort}")
  }

  if (!is.null(desc) && desc %in% c(0, 1)) {
    desc <- glue::glue("desc={desc}")
  }

  opts <- create_query(query, page, sort, desc)

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}/hledat?{opts}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get record detail
#'
#' @param dataset_id ID of dataset
#' @param item_id ID of record
#' @param token Authorization token
#'
#' @return list of vectors containing data related to the item
#' @export
#' @family Datasets
#' @examples
#' \dontrun{
#' get_dataset_record_detail("ministri", item_id = 1, token = "XXXX")
#' }
#' @seealso
#' \code{\link{get_dataset_data}}
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_dataset_record_detail <- function(dataset_id, item_id, token = NULL) {
  check_token(token)
  check_connection()

  response <- httr::GET(
    glue::glue(
      "https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}/zaznamy/{item_id}"
    ),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get company details
#'
#' @param company_name Name of the company
#' @param token Access token
#' @return list with 3 elements:
#' - ICO: ID number of the company
#' - Jmeno: Name of the company
#' - DatoveSchranky: Data post box - electronic repository for communication between
#' public institutions and private companies/people
#' @export
#' @family Companies
#' @examples
#' \dontrun{
#' get_company("Agrofert", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_company <- function(company_name, token = NULL) {
  check_token(token)
  check_connection()

  company_name <- urltools::url_encode(company_name)
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/firmy/{company_name}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get person details
#'
#' @param person_id Person's ID
#' @param token Access token
#' @return list with the following elements:
#' - TitulPred: academic titles written before person's name
#' - Jmeno: given name
#' - Prijmeni: surname
#' - TitulPo: academic titles written after person's name (if applicable)
#' - Narozeni: date of birth
#' - NameId: person's id
#' - Profile: URL of profile at hlidacstatu.cz
#' - Sponzoring: data.frame with data on sponsorship of political parties
#' by the person
#' - Udalosti: events related to the person such as party membership and
#' running in election, serving in political bodies and relations to private
#' companies (sharesholder, serving on a board)
#' - SocialniSite: data.frame with data on social media accounts
#' @export
#' @family Persons
#' @examples
#' \dontrun{
#' get_person("andrej-babis", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_person <- function(person_id, token = NULL) {
  check_token(token)
  check_connection()

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/osoby/{person_id}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get person details
#'
#' @param query Search query for a person, required parameter
#' @param party Search query for a political party
#' @param token Access token
#'
#' @return data.frame with found persons with the following columns:
#' - Jmeno: given name
#' - Prijmeni: surname
#' - Narozeni: date of birth
#' - NameId: person's ID
#' - Profile: URL of profile at hlidacstatu.cz
#' - TitulPred: academic titles written before person's name
#' - TitulPo: academic titles written after person's name
#' @export
#' @family Persons
#' @examples
#' \dontrun{
#' search_person(query = "Kalousek", token = "XXXX")
#' search_person(query = "Kalousek", party = "TOP 09", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
search_person <- function(query, party = NULL, token = NULL){
  check_token(token)
  check_connection()

  if (is.null(query)) {
    usethis::ui_stop("Query is required.")
  }else{
    query <- urltools::url_encode(query)
    query <- glue::glue("dotaz={query}")
  }

  if (!is.null(party)) {
    party <- urltools::url_encode(party)
    party <- glue::glue("strana={party}")
  }

  opts <- create_query(query, party)

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/osoby/hledat?{opts}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get person social media accounts
#'
#' @param types Types of social media accounts, only the following types are allowed:
#' 'Twitter', 'Facebook_page', 'Facebook_profile', 'Instagram', 'WWW', 'Youtube'
#' @param token Access token
#' @return data.frame with data on persons' social accounts with the
#' following columns:
#' - TitulPred: academic titles written before person's name
#' - Jmeno: given name
#' - Prijmeni: surname
#' - TitulPo: academic titles written after person's name
#' - NameId: person's ID
#' - Profile: URL of profile at hlidacstatu.cz
#' - SocialniSite: data.frame with data on social accounts (Type of social media,
#' Id of the social media account, URL)
#' @export
#' @family Persons
#' @examples
#' \dontrun{
#' get_person_social(types = c("Twitter", "Instagram"), token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_person_social <- function(types, token){
  check_token(token)
  check_connection()

  check_types(types)
  opts <- create_type(types)

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/osoby/social?{opts}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Search contract
#'
#' @param query Search query
#' @param page Page of results
#' @param sort Ordering of the results, the available options are the following:
#' - 0: sort by relevance
#' - 1: recently added contracts first
#' - 2: recently added contracts last
#' - 3: the cheapest contracts first
#' - 4: the most expensive contracts first
#' - 5: recently concluded contracts first
#' - 6: recently concluded contracts last
#' - 7: the most defective contracts first
#' - 8: sort by purchaser
#' - 9: sort by supplier
#' @param token Access token
#'
#' @return list containing 3 elements:
#' - Total: Total number of datasets available (integer)
#' - Page: Page of the result (integer)
#' - Results: Data.frame with data concerning the datasets
#'
#' @export
#' @family Contracts
#' @examples
#' \dontrun{
#' search_contracts(query = "golf", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
search_contracts <- function(query, token = NULL, page = 1, sort = 0) {
  check_token(token)
  check_connection()

  if (!is.null(query)) {
    query <- urltools::url_encode(query)
    query <- glue::glue("dotaz={query}")
  }

  if (!is.null(page)) {
    page <- glue::glue("strana={page}")
  }

  if (!is.null(sort)) {
    sort <- glue::glue("razeni={sort}")
  }

  opts <- create_query(query, page, sort)

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/hledat?{opts}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get contract details
#'
#' @param id ID of contract
#' @param token Authorization token
#'
#' @return list with data
#'
#' @export
#' @examples
#' \dontrun{
#' get_contract(id = "1086905", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_contract <- function(id, token = NULL) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/{id}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get contract text
#'
#' @param id ID of contract
#' @param token Authorization token
#'
#' @return Character vector containing text of the contract
#'
#' @export
#' @examples
#' \dontrun{
#' get_contract_text(id = "1086905", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_contract_text <- function(id, token = NULL) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/text/{id}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get websites
#'
#' @param token Authorization token
#'
#' @return data.frame with data on websites run by the state with the following
#' columns:
#' - hostid: ID of website
#' - host: host of website
#' - url: URL of website
#' - opendataUrl: URL to open data on website's availability
#' - pageUrl: URL to website's profile at Hlidac statu
#' - urad: the institution running the website
#' - publicname: name of the website
#' - popis: description of the website
#' - hash
#'
#' @export
#' @examples
#' \dontrun{
#' get_websites(token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_websites <- function(token = NULL) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/Weby"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get website detail
#'
#' @param id Website id
#' @param token Authorization token
#'
#' @return list with 2 elements:
#' - Availability: data on availability of the website
#' including response time and HTTP status code every minute
#' - SSL: assessment of the website's SSL server configuration
#'
#' @export
#' @examples
#' \dontrun{
#' get_website_detail(id = "10107", token = "XXXX")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_website_detail <- function(id, token = NULL) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/Weby/{id}"),
    httr::add_headers(Authorization = token)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}
