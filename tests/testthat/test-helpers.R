response_401 <- list(status_code = 401)
response_404 <- list(status_code = 404)

test_that("error is handled properly", {
    expect_error(handle_error_response(response_401),
                   message = "HTTP Error 401 when connecting to Hlidac statu. Probably invalid token.")
    expect_error(handle_error_response(response_404),
                   message = "HTTP Error 404 when connecting to Hlidac statu. Not found.")
})


test_that("queries are created properly", {
    expect_equal(create_query("page=1"), "page=1")
    expect_equal(create_query("page=1", "sort=0"), "page=1&sort=0")
})

test_that("types of social is valid", {
    expect_error(check_types(NULL),
                 message = "No types specified. You need to specify at least one of the following types: 'Twitter', 'Facebook_page', 'Facebook_profile', 'Instagram', 'WWW', 'Youtube'")
    expect_error(check_types("nevim"),
                 message = "nevim is an invalid type of social media account")
    expect_error(check_types(c("nevim", "nic", "Twitter")),
                 message = "nevim and nic is an invalid type of social media account")
})

test_that("query of social media account types is created properly", {
          expect_equal(create_type("Twitter"), "typ=Twitter")
          expect_equal(create_type(c("Twitter", "WWW")),
                       "typ=Twitter&typ=WWW")
})
