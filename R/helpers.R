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

