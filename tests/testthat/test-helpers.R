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
