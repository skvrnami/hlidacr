test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

response_401 <- list(status_code = 401)
response_404 <- list(status_code = 404)

test_that("error is handled properly", {
    expect_error(handle_error_response(response_401),
                   message = "HTTP Error 401 when connecting to Hlidac statu. Probably invalid token.")
    expect_error(handle_error_response(response_404),
                   message = "HTTP Error 404 when connecting to Hlidac statu. Not found.")
})
