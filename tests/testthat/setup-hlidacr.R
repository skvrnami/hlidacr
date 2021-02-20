library(vcr)

invisible(vcr::vcr_configure(
    dir = vcr::vcr_test_path("fixtures"),
    filter_request_headers = list(Authorization = "My token is safe")
))

if (!nzchar(Sys.getenv("HLIDAC_TOKEN"))) {
    if (dir.exists(vcr::vcr_test_path("fixtures"))) {
        # Fake API token to fool our package
        Sys.setenv("HLIDAC_TOKEN" = "foobar")
    } else {
        # If there's no mock files nor API token, impossible to run tests
        stop("No API key nor cassettes, tests cannot be run.",
             call. = FALSE)
    }
}

vcr::check_cassette_names()
