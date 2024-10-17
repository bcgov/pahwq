# Copyright 2023 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

test_that("kd_305 works at extremes of DOC", {
  expect_snapshot(round(kd_305(0.2), 2))
  expect_snapshot(round(kd_305(10), 2))
  expect_snapshot(round(kd_305(61), 2))
})

test_that("kd_305 replaces when outside DOC range", {
  expect_snapshot(round(kd_305(0.1), 2))
  expect_snapshot(round(kd_305(62), 2))

  expect_warning(
    expect_equal(
      kd_305(0.1),
      kd_305(0.2)
    )
  )

  expect_warning(
    expect_equal(
      kd_305(62),
      kd_305(61.45)
    )
  )
})

test_that("kd_lambda works at extremes of wavelengths", {
  expect_snapshot(round(kd_lambda(10, 280), 2))
  expect_snapshot(round(kd_lambda(10, 305), 2))
  expect_snapshot(round(kd_lambda(10, 400), 2))
})

test_that("kd_marine works at extremes of wavelengths", {
  expect_snapshot(round(kd_marine(280), 2))
  expect_snapshot(round(kd_marine(305), 2))
  expect_snapshot(round(kd_marine(400), 2))
})
