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
  expect_equal(round(kd_305(0.2), 2), 0.51)
  expect_equal(round(kd_305(10), 2), 47.00)
  expect_equal(round(kd_305(23), 2), 130.70)
})

test_that("kd_lambda works at extremes of wavelengths", {
  expect_equal(round(kd_lambda(10, 280), 2), c("280" = 73.71))
  expect_equal(round(kd_lambda(10, 305), 2), c("305" = 47.00))
  expect_equal(round(kd_lambda(10, 400), 2), c("400" = 8.50))
})
