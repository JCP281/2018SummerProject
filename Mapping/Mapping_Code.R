
# Mapping Data - Geospatial Analysis
# MSDA Summer 2018 Project
# Steele,Perry,Magnusson

require(caret)
require(sqldf)
require(maps)
require(sp)
require(maptools)

#UK coord
require(rgdal)
require(spdplyr)

# Create Coordinartes only data frame
setwd("C:/Users/Patrick Magnusson/Desktop/2018SummerProject")

acc = read.csv(file="AccidentDataFinal.csv",header=T)

acc$Accident_Index = acc[,1]
acc = acc[,-1]

coordinates = acc[,c("Accident_Index","Longitude","Latitude")]
write.csv(x = coordinates, file = "Mapping/coordinates2.csv")


# Load Shapefile (see sources below)

setwd("C:/Users/Patrick Magnusson/Desktop/2018SummerProject/Mapping")
uk_county_coord = readOGR(dsn = "Shapefile",
                        layer="English Ceremonial Counties")     
# updated previous Shapefile, which was missing Cornwall, Isle of Man, and Northumberland 
# old Shapefile stored as Shapefile_bad
uk_county_coord

wgs84 = '+proj=longlat +datum=WGS84'
uk_county_latLong = spTransform(uk_county_coord, CRS(wgs84)) # change geocode from TMERC to Lat/Long
uk_county_latLong
plot(uk_county_latLong, cex=2.5)



# Filter, Plot, and test Overlay on Shapefile
coord_narm = subset(coordinates, is.na(coordinates$Longitude)==FALSE)
coord_narm = subset(coord_narm, is.na(coord_narm$Latitude)==FALSE)
coord_narm_trans = coord_narm

coordinates(coord_narm) = ~Longitude+Latitude
proj4string(coord_narm) = proj4string(uk_county_latLong)

plot(uk_county_latLong, cex=2.5)
points(coord_narm, pch=0.01, col="red")

overlay = over(coord_narm, uk_county_latLong)
head(overlay)

coord_narm_trans = cbind.data.frame(coord_narm_trans, County=over(coord_narm, uk_county_latLong)$NAME)



# Return County column to original 'acc' dataset

accCounty = sqldf("SELECT a.*, b.County
                  FROM acc as a
                  LEFT JOIN coord_narm_trans as b
                  ON a.Accident_Index = b.Accident_Index")
accCounty$County = as.factor(accCounty$County)
summary(accCounty$County) # lots of NAs, due to Scotland not being included in govt Shapefile. Can only use England Counties

accCounty = subset(accCounty, is.na(accCounty$County)==FALSE)
#write.csv(x=accCounty, file="Accident_Data_Final_w_County.csv")







### Sources:
# Boundary Data: https://borders.ukdataservice.ac.uk/easy_download_data.html?data=infuse_cnty_lyr_2011
# County shapefile: https://data.gov.uk/dataset/0fb911e4-ca3a-4553-9136-c4fb069546f9/ceremonial-county-boundaries-of-england
# Spatial file read: https://www.zevross.com/blog/2016/01/13/tips-for-reading-spatial-files-into-r-with-rgdal/
# using data: https://blog.exploratory.io/making-maps-for-uk-countries-and-local-authorities-areas-in-r-b7d222939597
# map overlay: https://stackoverflow.com/questions/24174042/matching-georeferenced-data-with-shape-file-in-r
# tableau geocode: https://interworks.com/blog/ktreadwell/2012/11/01/adding-custom-geocoding-tableau/
