library(readxl)
library(dplyr)
library(purrr)
library(janitor)

abstracts <- read_excel("NHS-R Community Conference 2023 Call for Abstracts - Final List & Review Tracker V1.2.xlsx", 
                        skip = 1) |> 
  janitor::clean_names() |> 
  select(user_no,
         reviewer_1,
         reviewer_2)

# list of reviewers vector
source(paste0(here::here(), "/secrets/", "source_file.R"))

purrr::map(
  .x = list_reviewers,
  .f = function(name) {
    
    file_name <- glue::glue("C:\\Users\\zoe.turner\\Midlands and Lancashire CSU\\NHS-R Team - Conference\\Conference 2023\\Abstracts\\Peer Review\\{file_name}\\NHS-R Abstract Review Scorecard - {file_name}.xlsx",
                            file_name = name)
    
    person_data <- read_excel(file_name,
                              skip = 6) |> 
      janitor::clean_names()
    
    abstracts |> 
      filter(reviewer_1 == name | reviewer_2 == name) |> 
      left_join(person_data, join_by(user_no == x1)) |> 
      filter(is.na(x8))
  }
)

# name_file <- stringr::word(file_name, -2, -1)
# name <- stringr::str_remove(name_file, ".xlsx")