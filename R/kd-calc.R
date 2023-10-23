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

kd_lambda <- function(DOC, lambda) {
  # eqn 4-3, ARIS 2023
  Sk <- 0.018 #nm^-1
  kback <- 0

  kd305 <- kd_305(DOC)

  kdlambda <- kd305 * exp(Sk * (305 - lambda)) + kback
  names(kdlambda) <- as.character(lambda)
  round(kdlambda, 2)
}

kd_305 <- function(DOC) {
  # eqn 4-1a, ARIS 2023
  a305 <- 2.76
  b305 <- 1.23

  kd305 <- a305 * DOC^b305 + 0.13
  round(kd305, 2)
}
