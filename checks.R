library(readxl)
library(dplyr)
library(purrr)
library(janitor)

abstracts <- read_excel("secrets\\NHS-R Community Conference 2023 Call for Abstracts - Final List & Review Tracker V1.2.xlsx", 
                        skip = 1) |> 
  janitor::clean_names() |> 
  select(user_no,
         reviewer_1,
         reviewer_2)

# list of reviewers vector
source(paste0(here::here(), "/secrets/", "source_file.R"))

df <- purrr::map_df(
  .x = list_reviewers,
  .f = function(name) {
    
    file_name <- glue::glue("secrets\\{file_name}\\NHS-R Abstract Review Scorecard - {file_name}.xlsx",
                            file_name = name)
    
    person_data <- read_excel(file_name,
                              skip = 6) |> 
      janitor::clean_names()
    
    abstracts |> 
      filter(reviewer_1 == name | reviewer_2 == name) |> 
      left_join(person_data, join_by(user_no == x1)) |> 
      filter(!is.na(x8))
  }
)

writexl::write_xlsx(df, "final.xlsx")
