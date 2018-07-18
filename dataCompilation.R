

# Project - Predicting Road Accident Frequency: United Kingdom 1979-2014
# UTSA MSDA Summer 2018
# Robert Steele, James Perry, Patrick Magnusson


###  Data Compilation script
###  Data were originally stored in multiple csv files, with common key Accident_Index
###  Need to read and combine into a single dataset for project use





setwd("~/GitHub/DDDM_Project_SteelePerryMagnusson")
# substitute ~ with path to respository on one's PC

require(sqldf)
require(plyr)




# Accidents

accidentsNew = read.csv(file = "Raw Data/Accidents0514.csv", header=T, sep=",", na.strings=c("NULL",""," ","NA","N/A"))
accidentsNew$accident_Index = accidentsNew[,1]    # character error for column name read-in, creates attribute with an umlaut-i. Replacing.
accidentsNew = accidentsNew[,-1]
accidentsNew$Longitude = as.factor(accidentsNew$Longitude)
accidentsNew$Latitude = as.factor(accidentsNew$Latitude)


accidentsOld = read.csv(file = "Raw Data/Accidents7904.csv", header=T, sep=",",na.strings=c("NULL",""," ","NA","N/A"))
accidentsOld$accident_Index = accidentsOld[,1]
accidentsOld = accidentsOld[,-1]


accidentsAll = sqldf("
                    SELECT *
                    FROM accidentsNew
                    UNION ALL
                    SELECT *
                    FROM accidentsOld
                    ORDER BY accident_Index DESC
                    ")
write.csv(accidentsAll, file="Raw Data/accidentsAll.csv")
rm(accidentsNew)
rm(accidentsOld)


## Casualties

casualtiesNew = read.csv(file = "Raw Data/Casualties0514.csv", header=T, sep=",", na.strings=c("NULL",""," ","NA","N/A"))
casualtiesNew$accident_Index = casualtiesNew[,1]
casualtiesNew = casualtiesNew[,-1]
casualtiesNew = casualtiesNew[,-5]
casualtiesOld = read.csv(file = "Raw Data/Casualty7904.csv", header=T, sep=",",na.strings=c("NULL",""," ","NA","N/A"))
casualtiesOld$accident_Index = casualtiesOld[,1]
casualtiesOld = casualtiesOld[,-1]

casualtiesAll = sqldf("SELECT *
                      FROM casualtiesNew
                      UNION ALL
                      SELECT * 
                      FROM casualtiesOld
                      ORDER BY accident_Index DESC")
write.csv(casualtiesAll, file="Raw Data/casualtiesAll.csv")
rm(casualtiesNew)
rm(casualtiesOld)


## Vehicles

vehiclesNew = read.csv(file = "Raw Data/Vehicles0514.csv", header=T, sep=",",na.strings=c("NULL",""," ","NA","N/A"))
vehiclesNew$accident_Index = vehiclesNew[,1]
vehiclesNew = vehiclesNew[,-1]
vehiclesNew = vehiclesNew[,-15]
vehiclesOld = read.csv(file = "Raw Data/Vehicles7904.csv", header=T, sep=",",na.strings=c("NULL",""," ","NA","N/A"))
vehiclesOld$accident_Index = vehiclesOld[,1]
vehiclesOld = vehiclesOld[,-1]


vehiclesAll = sqldf("SELECT *
                    FROM vehiclesNew
                    UNION ALL
                    SELECT * 
                    FROM vehiclesOld
                    ORDER BY accident_Index DESC")
write.csv(vehiclesAll, file="Raw Data/vehiclesAll.csv")
rm(vehiclesOld)
rm(vehiclesNew)







## Final Combination ( does not run, ----------------------------------------

#memory.size()
#memory.limit()


#accCas = sqldf("SELECT DISTINCT *
#               FROM accidentsAll as a
#               INNER JOIN casualtiesAll as b
#               ON a.accident_Index = b.accident_Index
#               ORDER BY a.accident_Index DESC")

#rm(accidentsAll)
#rm(casualtiesAll)

#write.csv(x=accCas, file="Raw Data/accCas.csv")

#accCas = accCas[,-32]

#dataCrashesCompiled = sqldf("SELECT *
#                            FROM accCas as a
#                            INNER JOIN vehiclesAll as b
#                            ON a.accident_Index = b.accident_Index
#                            ORDER BY a.accident_Index DESC")

#dataCrashesCompiled = dataCrashesCompiled[]

#rm(vehiclesAll)
#rm(accCas)

#write.csv(x = dataCrashesCompiled, 
#          file = "Raw Data/dataCrashesCompiled.csv")



