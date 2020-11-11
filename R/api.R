#' Handle response other than 200
#'
#' @param response Response from the server
handle_error_response <- function(response){
    msg <- paste("HTTP Error", response$status_code,
                 "when connecting to Hlídač státu.")

    if(response$status_code == 401){
        msg <- paste(msg, "Probably invalid token.")
    }

    if(response$status_code == 404){
        msg <- paste(msg, "Not found.")
    }

    stop(msg, call. = FALSE)
}

#' Create query string
#'
#' @param ... query variables
create_query <- function(...){
    paste0(purrr::compact(list(...)), collapse = "&")
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
    response <- httr::GET("https://www.hlidacstatu.cz/Api/v2/datasety/",
               httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }else{
        jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
    }
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
    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}"),
                    httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }else{
        jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
    }
}

# get_dataset_metadata("ministri", token = NULL)
# get_dataset_metadata("ministri2", token = token)

#' Get data from the dataset
#'
#' @param dataset_id ID of dataset
#' @param query Search query
#' @param page Number of page
#' @param sort Sort by column
#' @param desc Descending or ascending sorting
#' @param token Authorization token
get_dataset_data <- function(dataset_id, query = NULL, page = 1, sort = NULL, desc = NULL, token){
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
    }else{
        jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
    }
}

# ministers1 <- get_dataset_data("ministri", query = "Zeman", token = token)

#' Get record detail
#'
#' @param dataset_id ID of dataset
#' @param item_id ID of record
#' @param token Authorization token
get_dataset_record_detail <- function(dataset_id, item_id, token){
    response <- httr::GET(glue::glue(
        "https://www.hlidacstatu.cz/Api/v2/datasety/{dataset_id}/zaznamy/{item_id}"),
                    httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }else{
        jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
    }
}

#' Get company details
#'
#' @param company_name Name of the company
#' @param token Access token
get_company <- function(company_name, token){
    response <- httr::GET(glue::glue("https://www.hlidacstatu.cz/Api/v2/firmy/{company_name}"),
                    httr::add_headers(Authorization = token))
    if(response$status_code != 200){
        handle_error_response(response)
    }else{
        jsonlite::fromJSON(stringr::str_conv(response$content, "UTF-8"))
    }
}
