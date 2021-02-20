test_that("get_datasets() works", {
    vcr::use_cassette("get_datasets", {
        datasets <- get_datasets(token = Sys.getenv("HLIDAC_TOKEN"))
    })
    testthat::expect_type(datasets, "list")
    testthat::expect_type(datasets$Total, "integer")
    testthat::expect_true(datasets$Total > 0)
    testthat::expect_type(datasets$Page, "integer")
    testthat::expect_true(inherits(datasets$Results, "data.frame"))
    testthat::expect_equal(datasets$Total, nrow(datasets$Results))
})

test_that("get_dataset_metadata() works", {
    vcr::use_cassette("get_dataset_metadata", {
        dataset_metadata <- get_dataset_metadata("ministri",
                                                 token = Sys.getenv("HLIDAC_TOKEN"))
    })
    testthat::expect_type(dataset_metadata, "list")
    testthat::expect_type(dataset_metadata$id, "character")
})

test_that("get_dataset_data() works", {
    vcr::use_cassette("get_dataset_data", {
        dataset_data <- get_dataset_data("ministri",
                                         token = Sys.getenv("HLIDAC_TOKEN"))
        dataset_query <- get_dataset_data("ministri",
                                          token = Sys.getenv("HLIDAC_TOKEN"),
                                          query = "Zeman")
    })

    testthat::expect_type(dataset_data, "list")
    testthat::expect_type(dataset_data$Total, "integer")
    testthat::expect_true(dataset_data$Total > 0)
    testthat::expect_type(dataset_data$Page, "integer")
    testthat::expect_true(inherits(dataset_data$Results, "data.frame"))

    testthat::expect_type(dataset_query, "list")
    testthat::expect_type(dataset_query$Total, "integer")
    testthat::expect_true(dataset_query$Total > 0)
    testthat::expect_type(dataset_query$Page, "integer")
    testthat::expect_true(inherits(dataset_query$Results, "data.frame"))

})

test_that("get_dataset_record_detail() works", {
    vcr::use_cassette("get_dataset_record_detail", {
        rec_detail <- get_dataset_record_detail("ministri", 1,
                                                token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(rec_detail, "list")
    testthat::expect_type(rec_detail$vlada, "character")
})

test_that("get_company() works", {
    vcr::use_cassette("get_company", {
        company <- get_company("Agrofert", token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(company, "list")
    testthat::expect_type(company$ICO, "character")
    testthat::expect_type(company$Jmeno, "character")
})

test_that("get_person() works", {
    vcr::use_cassette("get_person", {
        person <- get_person("andrej-babis", token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(person, "list")
    testthat::expect_type(person$Jmeno, "character")
    testthat::expect_type(person$Prijmeni, "character")
    testthat::expect_true(inherits(person$SocialniSite, "data.frame"))
    testthat::expect_true(inherits(person$Sponzoring, "data.frame"))
    testthat::expect_true(inherits(person$Udalosti, "data.frame"))
})

test_that("search_person() works", {
    vcr::use_cassette("search_person", {
        found_person1 <- search_person(query = "Kalousek",
                                       party = "TOP 09",
                                       token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_true(inherits(found_person1, "data.frame"))
})

test_that("get_person_social() works", {
    vcr::use_cassette("get_person_social", {
        socials <- get_person_social(c("Twitter", "Instagram"),
                                     token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_true(inherits(socials, "data.frame"))
})

test_that("search_contracts() works", {
    vcr::use_cassette("search_contracts", {
        contracts <- search_contracts("golf",
                                      token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(contracts, "list")
    testthat::expect_type(contracts$Total, "integer")
    testthat::expect_type(contracts$Page, "integer")
    testthat::expect_true(inherits(contracts$Results, "data.frame"))
})

test_that("get_contract() works", {
    vcr::use_cassette("get_contract", {
        contract1 <- get_contract("3583464",
                                  token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(contract1, "list")
})

test_that("get_contract_text() works", {
    vcr::use_cassette("get_contract_text", {
        contract_text <- get_contract_text("3583464",
                                           token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(contract_text, "character")
})

test_that("get_websites() works", {
    vcr::use_cassette("get_websites", {
        webs <- get_websites(token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_true(inherits(webs, "data.frame"))
})

test_that("get_website_detail() works", {
    vcr::use_cassette("get_website_detail", {
        web <- get_website_detail(id = "10107",
                                   token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(web, "list")
    testthat::expect_type(web$SSL, "list")
    testthat::expect_true(inherits(web$Availability$Data, "data.frame"))
})
