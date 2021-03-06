library(rvest)
library(dplyr)
library(lubridate)

#Konkurser i Troms 2018
browseURL("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2018&datoTil=07.10.2018&id_region=100&id_fylke=19&id_kommune=-+-+-&id_niva1=51&id_niva2=-+-+-&id_bransje1=0")
br_reg <- read_html("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2018&datoTil=07.10.2018&id_region=100&id_fylke=19&id_kommune=-+-+-&id_niva1=51&id_niva2=-+-+-&id_bransje1=0")

br_reg <- br_reg %>% html_table(fill = TRUE)
df <- br_reg[[5]]
head(df, n=10)
tail(df)

df <- df[-c(1:6),c(2,4,6,8)]
head(df)
names(df) <- c("Navn", "Org. nr", "Dato", "Hendelse")
str(df)

tvangsoppl <- df %>%
   filter(Hendelse == "Tvangsoppl�sning")

tvangsoppl$Dato <- dmy(tvangsoppl$Dato)
tvangsoppl <- arrange(tvangsoppl, Dato)

#Fors�kte � finne/lage en funksjon som telte hvor mange rader som var innenfor et tidsintervall 
#p� en m�ned, men klarte ikke dette. Fors�kte � "group by" etter dato eller m�ned, men siden observasjonene
#ikke har noen verdi � bruke summarise() p�, satt jeg fast. Endte derfor opp med en tungvint, men gjennomf�rbar l�sning.   

month_jan <- nrow(filter(tvangsoppl, Dato > "2017-12-31" & Dato < "2018-02-01"))
month_feb <- nrow(filter(tvangsoppl, Dato > "2018-01-31" & Dato < "2018-03-01"))
month_mar <- nrow(filter(tvangsoppl, Dato > "2018-02-28" & Dato < "2018-04-01"))
month_apr <- nrow(filter(tvangsoppl, Dato > "2018-03-31" & Dato < "2018-05-01"))
month_mai <- nrow(filter(tvangsoppl, Dato > "2018-04-30" & Dato < "2018-06-01"))
month_jun <- nrow(filter(tvangsoppl, Dato > "2018-05-31" & Dato < "2018-07-01"))
month_jul <- nrow(filter(tvangsoppl, Dato > "2018-06-30" & Dato < "2018-08-01"))
month_aug <- nrow(filter(tvangsoppl, Dato > "2018-07-31" & Dato < "2018-09-01"))
month_sep <- nrow(filter(tvangsoppl, Dato > "2018-08-31" & Dato < "2018-10-01"))

mnd <- c("Januar", "Februar", "Mars", "April", "Mai", "Juni", "Juli", "August", "September")
antall <- c(month_jan, month_feb, month_mar, month_apr, month_mai, month_jun, month_jul, month_aug, month_sep)
tvangs_mnd <- data.frame(mnd, antall)
barplot(antall, main = "Konkurser i Troms 2018", names.arg = mnd)
