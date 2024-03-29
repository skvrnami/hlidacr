#' Check internet connection
#' @return No return value, called for side effects
check_connection <- function(){
    if(!curl::has_internet()) usethis::ui_stop("No internet connection. Cannot continue. Retry when connected.")
}

#' Check API token
#'
#' @param token API token to Hlidac statu
#' @return No return value, called for side effects
check_token <- function(token){
    if(is.null(token) || nchar(token) == 0) usethis::ui_stop("No token defined.")
}

#' Handle response other than 200
#'
#' @param response Response from the server
#' @return No return value, called for side effects
handle_error_response <- function(response){
    msg <- paste("HTTP Error", response$status_code,
                 "when connecting to Hlidac statu.")

    if(response$status_code == 400){
        hs_msg <- stringr::str_conv(response$content, "UTF-8")
        msg <- paste(msg, "Error message from Hlidac statu:", hs_msg)
    }

    if(response$status_code == 401){
        msg <- paste(msg, "Probably invalid token.")
    }

    if(response$status_code == 404){
        msg <- paste(msg, "Not found.")
    }

    # TODO: status code 500

    usethis::ui_stop(msg)
}

#' Check if all social media account types are valid
#'
#' @param types Vector with types of social media accounts
#' @return No return value, called for side effects
check_types <- function(types){
    if(!length(types)) usethis::ui_stop("No types specified. You need to specify at least one of the following types: 'Twitter', 'Facebook_page', 'Facebook_profile', 'Instagram', 'WWW', 'Youtube'")

    invalid_type <- types[!types %in% c("Twitter", "Facebook_page", "Facebook_profile", "Instagram",
                                        "WWW", "Youtube")]
    invalid_type_char <- paste(invalid_type, collapse = " and ")
    if(length(invalid_type) > 0) usethis::ui_stop("{invalid_type_char} is an invalid type of social media account")

}

#' Create query string for osoby/social API endpoint
#'
#' @param types Vector with types of social media accounts
#' @return String for querying API
create_type <- function(types){
    paste0(purrr::map_chr(types, ~paste0("typ=", .x)),
           collapse = "&")
}


