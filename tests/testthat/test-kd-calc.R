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
  expect_equal(kd_305(0.2), 0.51, tolerance = 0.01)
  expect_equal(kd_305(10), 47.00, tolerance = 0.01)
  expect_equal(kd_305(23), 130.70, tolerance = 0.01)
})

test_that("kd_lambda works at extremes of wavelengths", {
  expect_equal(kd_lambda(10, 280), c("280" = 73.71), tolerance = 0.01)
  expect_equal(kd_lambda(10, 305), c("305" = 47.00), tolerance = 0.01)
  expect_equal(kd_lambda(10, 400), c("400" = 8.501), tolerance = 0.01)
})
