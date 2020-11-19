#pdf to text
#install packages

#install.packages("tidyverse")
##dplyr, for data manipulation.
#tibble, for tibbles, a modern re-imagining of data frames.

#install.packages("pdftools")
#Text Extraction, Rendering and Converting of PDF Documents


#Load packages
library(pdftools)
library(tidyverse)

#load pdf file. Use pdf_text 
#the output of pdf_text() will go into read_lines() then the final output is assigned to PDF.
#readr,package for data import. read_lines() function reads the lines of our new file.

PDF <- pdf_text("oregon_grass_and_legume_seed_crops_preliminary_estimates_2019.pdf") %>%
  +     readr::read_lines() #open the PDF inside your project folder

#Check PDF data.
PDF

#Remove unnecessary lines  and store required data in PDF.grass
PDF.grass <-PDF[-c(1:3,6:8,20:35)]

#Check the data
PDF.grass

#select line 3:13 from PDF.grass and remove white spaces and empty spaces and store output in all_stat_lines
all_stat_lines <- PDF.grass[3:13] %>%
  str_squish() %>%  #reduces the repeated whitespace between each string
  strsplit(split = " ") # remove empty spaces

#check all_stat_lines
all_stat_lines[]

#Create variable names for header 
#c() - Combine Values Into A Vector Or List
var_lines <- c("Species", "Area Harvested(acres)", "Yield per acre(lbs.)", "Production(000 lbs.)", "Price($/cwt)", "Value of production(000$)" )

#check data
var_lines

#line 6 was the only species that does not had a compost name, 
#it is easier to separate this line now and join it with the other column later
all_stat_lines[[6]] <- c("Orchard", "grass","15,190","1,046","15,889","225.00","35,750") 

#check data
all_stat_lines[]

#Transform the data into a data frame
#Use the ldply() function in the plyr package
#Applies function to eachelement in a list and combines the results into a data frame df
df <- plyr::ldply(all_stat_lines) 
head(df)


#Joint column1 and column2 to create new column V1.2
df <- df %>% unite(V1.2, V1, V2, sep = " ")
df

#add thecolumn header name into a final data frame
colnames(df) <- var_lines
df

#as_tibble() turns a data frame or matrix,into tibble.
#“Tibbles” are a new modern data frame.
final_df <- as_tibble(df) 
final_df


# transform variables to numeric and factor. Remove , from numbers
final_df$Species <- as.factor(final_df$Species)
final_df$"Area Harvested(acres)" <- as.numeric(gsub(",","",final_df$"Area Harvested(acres)"))
final_df$"Yield per acre(lbs.)" <- as.numeric(gsub(",","",final_df$"Yield per acre(lbs.)"))
final_df$"Production(000 lbs.)" <- as.numeric(gsub(",","",final_df$"Production(000 lbs.)"))
final_df$"Price($/cwt)" <- as.numeric(gsub(",","",final_df$"Price($/cwt)"))
final_df$"Value of production(000$)" <- as.numeric(gsub(",","",final_df$"Value of production(000$)"))

#final dataset
final_df

#write to csv
write.csv(final_df,"C:\\Users\\kalya\\Documents\\Biogen\\MyData.csv", row.names = FALSE)  

#read csv file
text <- read.csv(file = 'MyData.csv')
head(text)


str(text)
text$Species
text$Area.Harvested.acres.

qplot(x = text$Species,
      y = text$Area.Harvested.acres.)
