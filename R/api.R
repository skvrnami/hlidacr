#' Get list of datasets
#'
#' Get list of datasets available via 'Hlídač státu' API
#'
#' @param token Authorization token
#'
#' @return Response from the server containing a list of all datasets available.
#' The list contains 3 elements:
#' - total: Total number of datasets available (integer)
#' - page: Page of the result (integer)
#' - results: data concerning the datasets (data.frame)
#' @export
#' @family Datasets
#' @examples
#' \dontrun{
#' get_datasets()
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_datasets <- function(token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    "https://www.hlidacstatu.cz/Api/v2/datasety/",
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' @return a list containing metadata related to the specified dataset
#' @export
#' @family Datasets
#' @examples
#' \dontrun{
#' get_dataset_metadata("ministri")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_dataset_metadata <- function(dataset_id, token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}"),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' @param page Number of page (Please note that if the page parameter exceeds 200, the function returns error)
#' @param sort Sort by column
#' @param desc Descending or ascending sorting
#'
#' @return list containing 3 elements:
#' - total: Total number of datasets available (integer)
#' - page: Page of the result (integer), equal to the `page` argument of the function
#' - results: Data.frame with data, columns vary depending on the dataset
#' @export
#' @family Datasets
#' @examples
#' \dontrun{
#' get_dataset_data("ministri")
#' get_dataset_data("ministri", query = "Zeman", page = 1)
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_dataset_data <- function(dataset_id, token = Sys.getenv("HLIDAC_TOKEN"),
                             query = NULL, page = 1, sort = NULL, desc = NULL) {
  check_token(token)
  check_connection()

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}/hledat"),
    query = list(dotaz = query,
                 strana = page,
                 sort = sort,
                 desc = desc),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' get_dataset_record_detail("ministri", item_id = 1)
#' }
#' @seealso
#' \code{\link{get_dataset_data}}
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_dataset_record_detail <- function(dataset_id, item_id,
                                      token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()

  response <- httr::GET(
    glue::glue(
      "https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}/zaznamy/{item_id}"
    ),
    httr::add_headers(Authorization = token,
                      user_agent)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Search subsidies
#'
#' @param query Search query
#' @param page Page number (Please note that if the page parameter exceeds 200, the function returns error)
#' @param sort Sorting of results, the available options are the following:
#' - 0: order by relevance
#' - 1: order by the date of signature, the most recent first
#' - 2: order by the date of signature, the most recent last
#' - 3: order by the size of the subsidy, the largest first
#' - 4: order by the size of the subsidy, the largest last
#' - 5: order by ICO in a descending order
#' - 6: order by ICO in an ascending order
#' @param token Authorization token
#'
#' @return list containing 3 elements:
#' - total: Total number of datasets available (integer)
#' - page: Page of the result (integer), equal to the `page` argument of the function
#' - results: Data.frame with data, columns vary depending on the dataset
#' @export
#' @family Subsidies
#' @examples
#' \dontrun{
#' search_subsidies("golf")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
search_subsidies <- function(query, page = 1, sort = NULL,
                             token = Sys.getenv("HLIDAC_TOKEN")){
  check_token(token)
  check_connection()

  response <- httr::GET(
    "https://www.hlidacstatu.cz/api/v2/dotace/hledat",
    query = list(dotaz = query,
                 strana = page,
                 razeni = sort),
    httr::add_headers(Authorization = token,
                      user_agent)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get subsidy
#'
#' @param id Subsidy ID
#' @param token Authorization token
#'
#' @return list with details of the subsidy
#' @export
#' @family Subsidies
#' @examples
#' \dontrun{
#' get_subsidy("deminimis-1000229862")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_subsidy <- function(id, token = Sys.getenv("HLIDAC_TOKEN")){
  check_token(token)
  check_connection()

  response <- httr::GET(
    glue::glue(
      "https://www.hlidacstatu.cz/api/v2/dotace/{id}"
    ),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' - ico: ID number of the company
#' - jmeno: Name of the company
#' - datoveSchranky: Data post box - electronic repository for communication between
#' public institutions and private companies/people
#' @export
#' @family Companies
#' @examples
#' \dontrun{
#' get_company("Agrofert")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_company <- function(company_name, token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()

  company_name <- urltools::url_encode(company_name)
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/firmy/{company_name}"),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' - titulPred: academic titles written before person's name
#' - jmeno: given name
#' - prijmeni: surname
#' - titulPo: academic titles written after person's name (if applicable)
#' - narozeni: date of birth
#' - nameId: person's id
#' - profile: URL of profile at hlidacstatu.cz
#' - sponzoring: data.frame with data on sponsorship of political parties
#' by the person
#' - udalosti: events related to the person such as party membership and
#' running in election, serving in political bodies and relations to private
#' companies (shareholder, serving on a board)
#' - socialniSite: data.frame with data on social media accounts
#' @export
#' @family Persons
#' @examples
#' \dontrun{
#' get_person("andrej-babis")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_person <- function(person_id, token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/osoby/{person_id}"),
    httr::add_headers(Authorization = token,
                      user_agent)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Search person
#'
#' @param query Search query for a person, required parameter
#' @param page Page number
#' @param token Access token
#'
#' @return data.frame with found persons with the following columns:
#' - jmeno: given name
#' - prijmeni: surname
#' - narozeni: date of birth
#' - nameId: person's ID
#' - profile: URL of profile at hlidacstatu.cz
#' - titulPred: academic titles written before person's name
#' - titulPo: academic titles written after person's name
#' @export
#' @family Persons
#' @examples
#' \dontrun{
#' search_person(query = "Kalousek")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
search_person <- function(query, page = NULL,
                          token = Sys.getenv("HLIDAC_TOKEN")){
  check_token(token)
  check_connection()

  if (is.null(query)) {
    usethis::ui_stop("Query is required.")
  }

  response <- httr::GET(
    "https://www.hlidacstatu.cz/api/v2/osoby/hledatFtx",
    query = list(ftxDotaz = query,
                 strana = page),
    httr::add_headers(Authorization = token,
                      user_agent)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}


#' Search person by name and date of birth
#'
#' @param first_name Person's first name
#' @param last_name Person's last name
#' @param birth_date Person's date of birth (in YYYY-MM-DD format)
#' @param ignore_diacritics Parameter indicating whether diacritics in names should be ignored (boolean)
#' @param token Access token
#'
#' @return data.frame with found persons with the following columns:
#' - jmeno: given name
#' - prijmeni: surname
#' - narozeni: date of birth
#' - nameId: person's ID
#' - profile: URL of profile at hlidacstatu.cz
#' - titulPred: academic titles written before person's name
#' - titulPo: academic titles written after person's name
#' @export
#' @family Persons
#' @examples
#' \dontrun{
#' search_person_by_parameters(first_name = "Miroslav", last_name = "Kalousek",
#' birth_date = "1960-12-17")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
search_person_by_parameters <- function(first_name = NULL,
                                        last_name = NULL,
                                        birth_date = NULL,
                                        ignore_diacritics = TRUE,
                                        token = Sys.getenv("HLIDAC_TOKEN")){
  check_token(token)
  check_connection()

  if (is.null(first_name)) {
    usethis::ui_stop("first_name is required.")
  }

  if (is.null(last_name)) {
    usethis::ui_stop("last_name is required.")
  }

  if (is.null(birth_date)) {
    usethis::ui_stop("birth_date is required.")
  }

  response <- httr::GET(
    "https://www.hlidacstatu.cz/api/v2/osoby/hledat",
    query = list(jmeno = first_name,
                 prijmeni = last_name,
                 datumNarozeni = birth_date,
                 ignoreDiakritiku = ignore_diacritics),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' - titulPred: academic titles written before person's name
#' - jmeno: given name
#' - prijmeni: surname
#' - titulPo: academic titles written after person's name
#' - nameId: person's ID
#' - profile: URL of profile at hlidacstatu.cz
#' - socialniSite: data.frame with data on social accounts (Type of social media,
#' Id of the social media account, URL)
#' @export
#' @family Persons
#' @examples
#' \dontrun{
#' get_person_social(types = c("Twitter", "Instagram"))
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_person_social <- function(types, token = Sys.getenv("HLIDAC_TOKEN")){
  check_token(token)
  check_connection()

  check_types(types)
  opts <- create_type(types)

  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/osoby/social?{opts}"),
    httr::add_headers(Authorization = token,
                      user_agent)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Search contract
#'
#' @param query Full-text search query
#' @param page Page of results (Please note that if the page parameter exceeds 200, the function returns error)
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
#' search_contracts(query = "golf")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
#'
#' \url{https://www.hlidacstatu.cz/napoveda}
#'
#' \url{https://smlouvy.gov.cz/}
search_contracts <- function(query, token = Sys.getenv("HLIDAC_TOKEN"),
                             page = 1, sort = 0) {
  check_token(token)
  check_connection()

  if (is.null(query)) {
    usethis::ui_stop("Query is required.")
  }

  response <- httr::GET(
    "https://www.hlidacstatu.cz/api/v2/smlouvy/hledat",
    query = list(dotaz = query,
                 strana = page,
                 razeni = sort),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' get_contract(id = "1086905")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
#'
#' \url{https://smlouvy.gov.cz/}
get_contract <- function(id, token = NULL) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/{id}"),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' get_contract_text(id = "1086905")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
#'
#' \url{https://smlouvy.gov.cz/}
get_contract_text <- function(id, token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/text/{id}"),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' get_websites()
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_websites <- function(token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/Weby"),
    httr::add_headers(Authorization = token,
                      user_agent)
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
#' - availability: data on availability of the website
#' including response time and HTTP status code every minute
#' - ssl: assessment of the website's SSL server configuration
#'
#' @export
#' @examples
#' \dontrun{
#' get_website_detail(id = "10107")
#' }
#' @seealso
#' \url{https://www.hlidacstatu.cz/api/v2/swagger/index}
#'
#' \url{https://www.hlidacstatu.cz/api/v1/doc}
get_website_detail <- function(id, token = Sys.getenv("HLIDAC_TOKEN")) {
  check_token(token)
  check_connection()
  response <- httr::GET(
    glue::glue("https://www.hlidacstatu.cz/api/v2/Weby/{id}"),
    httr::add_headers(Authorization = token,
                      user_agent)
  )

  if (response$status_code != 200) {
    handle_error_response(response)
  }

  jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}
