#' Get list of datasets
#'
#' Get list of datasets available via Hlídač státu API
#'
#' @param token Authorization token
#'
#' @return Response from the server containing list of all datasets available
#' @export
#'
#' @examples
#' \dontrun{
#' get_datasets(token = "XXXX")
#' }
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
#' @return Response from the server containing metadata related to the specified dataset
#' @export
#'
#' @examples
#' \dontrun{
#' get_dataset_metadata("ministri", token = "XXXX")
#' }
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
#' @param query Search query
#' @param page Number of page
#' @param sort Sort by column
#' @param desc Descending or ascending sorting
#' @param token Authorization token
#' @export
#'
#' @examples
#' \dontrun{
#' get_dataset_data("ministri", token = "XXXX")
#' get_dataset_data("ministri", query = "Zeman", page = 1, token = "XXXX")
#' }
get_dataset_data <- function(dataset_id, token = NULL, query = NULL, page = 1, sort = NULL, desc = NULL) {
  check_token(token)
  check_connection()

  if (!is.null(query)) {
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
#' @export
#'
#' @examples
#' \dontrun{
#' get_dataset_record_detail("ministri", item_id = 1, token = "XXXX")
#' }
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
#' @export
#'
#' @examples
#' \dontrun{
#' get_company("Agrofert", token = "XXXX")
#' }
get_company <- function(company_name, token = NULL) {
  check_token(token)
  check_connection()

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
#' @export
#'
#' @examples
#' \dontrun{
#' get_person("andrej-babis", token = "XXXX")
#' }
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
#' @param query Search query for a person
#' @param party Search query for a political party
#' @param token Access token
#' @export
#'
#' @examples
#' \dontrun{
#' search_person(query = "Kalousek", party = "TOP 09", token = "XXXX")
#' }
search_person <- function(query, party, token = NULL){
  check_token(token)
  check_connection()

  if (!is.null(query)) {
    query <- glue::glue("dotaz={query}")
  }

  if (!is.null(party)) {
    page <- glue::glue("strana={party}")
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
#' @export
#'
#' @examples
#' \dontrun{
#' get_person_social(c("Twitter", "Instagram"), token = "XXXX")
#' }
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
#' @param sort Ordering of the results
#' @param token Access token
#' @export
#' @examples
#' \dontrun{
#' search_contracts("golf", token = "XXXX")
#' }
search_contracts <- function(query, token = NULL, page = 1, sort = 0) {
  check_token(token)
  check_connection()

  if (!is.null(query)) {
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
#' @export
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
#' @export
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
#' @export
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
#' @export
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
