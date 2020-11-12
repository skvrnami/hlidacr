#' Handle response other than 200
#'
#' @param response Response from the server
handle_error_response <- function(response){
    msg <- paste("HTTP Error", response$status_code,
                 "when connecting to Hlidac statu.")

    if(response$status_code == 401){
        msg <- paste(msg, "Probably invalid token.")
    }

    if(response$status_code == 404){
        msg <- paste(msg, "Not found.")
    }

    # TODO: status code 500

    usethis::ui_stop(msg)
}

#' Create query string
#'
#' @param ... query variables
create_query <- function(...){
    paste0(purrr::compact(list(...)), collapse = "&")
}

#' Check internet connection
check_connection <- function(){
    if(!curl::has_internet()) usethis::ui_stop("No internet connection. Cannot continue. Retry when connected.")
}

#' Get list of datasets
#'
#' Get list of datasets available via Hlídač státu API
#'
#' @param token Authorization token
#'
#' @return Response from the server containing list of all datasets available
#' @export
get_datasets <- function(token){
    check_connection()
    response <- httr::GET("https://www.hlidacstatu.cz/Api/v2/datasety/",
               httr::add_headers(Authorization = token))
    if(response$status_code != 200){
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
get_dataset_metadata <- function(dataset_id, token){
    check_connection()
    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}"),
                    httr::add_headers(Authorization = token))
    if(response$status_code != 200){
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
get_dataset_data <- function(dataset_id, query = NULL, page = 1, sort = NULL, desc = NULL, token){
    check_connection()

    if(!is.null(query)){
        query <- glue::glue("dotaz={query}")
    }

    if(!is.null(page)){
        page <- glue::glue("page={page}")
    }

    if(!is.null(sort)){
        sort <- glue::glue("sort={sort}")
    }

    if(!is.null(desc) && desc %in% c(0, 1)){
        desc <- glue::glue("desc={desc}")
    }

    opts <- create_query(query, page, sort, desc)

    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}/hledat?{opts}"),
                    httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

# ministers1 <- get_dataset_data("ministri", query = "Zeman", token = token)

#' Get record detail
#'
#' @param dataset_id ID of dataset
#' @param item_id ID of record
#' @param token Authorization token
#' @export
get_dataset_record_detail <- function(dataset_id, item_id, token){
    check_connection()

    response <- httr::GET(glue::glue(
        "https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}/zaznamy/{item_id}"),
                    httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get company details
#'
#' @param company_name Name of the company
#' @param token Access token
#' @export
get_company <- function(company_name, token){
    check_connection()

    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/api/v2/firmy/{company_name}"),
                    httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get company details
#'
#' @param person_id Person's ID
#' @param token Access token
#' @export
get_person <- function(person_id, token){
    check_connection()

    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/api/v2/osoby/{person_id}"),
                          httr::add_headers(Authorization = token))
    if(response$status_code != 200){
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
search_contracts <- function(query, page = 1, sort = 0, token){
    check_connection()

    if(!is.null(query)){
        query <- glue::glue("dotaz={query}")
    }

    if(!is.null(page)){
        page <- glue::glue("strana={page}")
    }

    if(!is.null(sort)){
        sort <- glue::glue("razeni={sort}")
    }

    opts <- create_query(query, page, sort)

    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/hledat?{opts}"),
                          httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get contract details
#'
#' @param id ID of contract
#' @param token Authorization token
#' @export
get_contract <- function(id, token){
    check_connection()
    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/{id}"),
                          httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get contract text
#'
#' @param id ID of contract
#' @param token Authorization token
#' @export
get_contract_text <- function(id, token){
    check_connection()
    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/api/v2/smlouvy/text/{id}"),
                          httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get websites
#'
#' @param token Authorization token
#' @export
get_websites <- function(token){
    check_connection()
    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/api/v2/Weby"),
                          httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
}

#' Get website detail
#'
#' @param id Website id
#' @param token Authorization token
#' @export
get_website_detail <- function(id, token){
    check_connection()
    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/api/v2/Weby/{id}"),
                          httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }
    jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))

}
