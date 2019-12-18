library(tidyverse)
library(dslabs)
data(temp_carbon)
data(greenhouse_gases)
data(historic_co2)

dif_celsius = temp_carbon %>%
  filter(!is.na(temp_anomaly) & year %in% c(1880, 2018)) %>%
  select(temp_anomaly)

p = temp_carbon %>%
  filter(!is.na(temp_anomaly)) %>%
  ggplot(aes(year, temp_anomaly)) +
  geom_line() +
  geom_line(aes(x = year, y = ocean_anomaly), color = "red") +
  geom_line(aes(x = year, y = land_anomaly), color = "yellow") +
  geom_hline(aes(yintercept = 0), col = "blue") +
  ylab("Temperature anomaly (degrees C)") +
  ggtitle("Temperature anomaly relative to 20th century mean, 1880-2018") +
  geom_text(x = 2000, y = 0.05, label = "20th century mean", color = "blue")

p2 = greenhouse_gases %>%
  ggplot(aes(year, concentration)) +
  geom_line() +
  facet_grid(gas~., scales = "free") +
  geom_vline(xintercept = 1850) +
  ylab("Concentration (ch4/n2o ppb, co2 ppm)") +
  ggtitle("Atmospheric greenhouse gas concentration by year, 0-2000")

p3 = temp_carbon %>%
  filter(!is.na(carbon_emissions)) %>%
  ggplot(aes(year, carbon_emissions)) +
  geom_line()

co2_time = historic_co2 %>%
  ggplot(aes(year, co2, color = source)) +
  geom_line()


co2_time + xlim(-30000, 2018)



