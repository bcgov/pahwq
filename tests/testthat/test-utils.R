test_that("tuv_data_dir works", {
  expect_equal(tuv_data_dir(), file.path(tools::R_user_dir("pahwq", "data"), "tuv_data"))
  tdir <- withr::local_tempdir()
  expect_equal(tuv_data_dir(tdir), tdir)
  expect_type(tuv_data_dir(), "character")
})

test_that("list_tuv_dir and clean_tuv_dir work", {
  tdir <- local_tuv_dir()
  expect_true(file.exists(tdir))
  expect_equal(
    basename(list_tuv_dir(tdir)),
    c(
      basename(
        list.files(system.file("tuv_data", package = "pahwq"),
                   recursive = TRUE)
      ),
      tuv_cmd()
    )
  )
  clean_tuv_dir(tdir)
  expect_false(file.exists(tdir))
})

test_that("sanitize_names works", {
  expect_equal(sanitize_names("FOO"), "foo")
  expect_equal(sanitize_names("FOO[b]"), "foo(b)")
  expect_equal(sanitize_names("benz[a]"), "benzo(a)")
  expect_equal(sanitize_names("benz[a-b]"), "benzo(a-b)")
  expect_equal(sanitize_names("benz[a,b,c]"), "benzo(abc)")
  expect_equal(sanitize_names("benz[a,b,c-1]"), "benzo(abc-1)")
})
