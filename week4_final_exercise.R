library(tidyverse)
library(WDI)
library(paletteer)


new_wdi_cache <- WDIcache()

countries_df <- WDI(country = "all",
                    indicator = "SP.DYN.LE00.IN",
                    extra = TRUE)

# examine existing income classes
unique(countries_df["income"])

# remove NA's or Not classified
countries_df_clean <- countries_df |> 
  filter(income %in% c("Low income", "Lower middle income", "Upper middle income", "High income")) |> 
  filter(!is.na(SP.DYN.LE00.IN))

# reorder the income classes
countries_df_clean$income <- factor(countries_df_clean$income,
                                    levels = c("Low income", "Lower middle income", "Upper middle income", "High income"))

  

# plot year against life expectancy of infants, grouping by income class
ggplot(data = countries_df_clean,
       mapping = aes(
         x = year,
         y = SP.DYN.LE00.IN,
         colour = income
       )) +
  geom_point(size = 2) +
  scale_colour_paletteer_d("nbapalettes::wizards_earned") +
  labs(
    x = "Year",
    y = "Life expectancy at birth (years)",
    colour = "Income",
    title = "Life expectancy of infants for different income countries, 1960 - 2020",
    caption = "Data Source: World Development Indicators (The World Bank) | Plot by Stuart Wilson"
  ) + 
  theme_minimal()



