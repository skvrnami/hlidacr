test_that("get_datasets() works", {
    vcr::use_cassette("get_datasets", {
        datasets <- get_datasets(token = Sys.getenv("HLIDAC_TOKEN"))
    })
    testthat::expect_type(datasets, "list")
    testthat::expect_type(datasets$Total, "integer")
    testthat::expect_true(datasets$Total > 0)
    testthat::expect_type(datasets$Page, "integer")
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
    testthat::expect_gt(nrow(dataset_data$Results), 0)

    testthat::expect_type(dataset_query, "list")
    testthat::expect_type(dataset_query$Total, "integer")
    testthat::expect_true(dataset_query$Total > 0)
    testthat::expect_type(dataset_query$Page, "integer")
    testthat::expect_gt(nrow(dataset_query$Results), 0)

})

test_that("get_dataset_record_detail() works", {
    vcr::use_cassette("get_dataset_record_detail", {
        rec_detail <- get_dataset_record_detail("ministri", 1,
                                                token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(rec_detail, "list")
    testthat::expect_type(rec_detail$vlada, "character")
})

test_that("search_subsidies() works", {
    vcr::use_cassette("search_subsidies", {
        golf_sub <- search_subsidies("golf", page = 1,
                                       token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(golf_sub, "list")
    testthat::expect_equal(nrow(golf_sub$Results), 25)
})

test_that("get_subsidy() works", {
    vcr::use_cassette("get_subsidy", {
        golf_sub1 <- get_subsidy("deminimis-1000229862",
                                 token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(golf_sub1, "list")
    testthat::expect_type(golf_sub1$IdDotace, "character")
    testthat::expect_type(golf_sub1$Prijemce, "list")
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
    testthat::expect_gt(nrow(person$SocialniSite), 0)
    testthat::expect_gt(nrow(person$Sponzoring), 0)
    testthat::expect_gt(nrow(person$Udalosti), 0)
})

test_that("search_person() works", {
    vcr::use_cassette("search_person", {
        found_person1 <- search_person(query = "Kalousek",
                                       party = "TOP 09",
                                       token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_gt(nrow(found_person1), 0)
})

test_that("get_person_social() works", {
    vcr::use_cassette("get_person_social", {
        socials <- get_person_social(c("Twitter", "Instagram"),
                                     token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_gt(nrow(socials), 0)
})

test_that("search_contracts() works", {
    vcr::use_cassette("search_contracts", {
        contracts <- search_contracts("golf",
                                      token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(contracts, "list")
    testthat::expect_type(contracts$Total, "integer")
    testthat::expect_type(contracts$Page, "integer")
    testthat::expect_gt(nrow(contracts$Results), 0)
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

    testthat::expect_gt(nrow(webs), 0)
})

test_that("get_website_detail() works", {
    vcr::use_cassette("get_website_detail", {
        web <- get_website_detail(id = "10107",
                                   token = Sys.getenv("HLIDAC_TOKEN"))
    })

    testthat::expect_type(web, "list")
    testthat::expect_type(web$SSL, "list")
    testthat::expect_gt(nrow(web$Availability$Data), 0)
})
