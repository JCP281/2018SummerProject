
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

setwd("C:/Users/patri/Desktop/2018SummerProject")

acc = read.csv(file="Accidents_05.15_Original_No_Impute.csv",header=T)

acc$Accident_Index = acc[,1]
acc = acc[,-1]

coordinates = acc[,c("Longitude","Latitude","Accident_Index")]
#write.csv(x = coordinates, file = "coordinates.csv")


setwd("C:/Users/patri/Desktop/2018SummerProject/Repository/Mapping")
uk_county_coord = readOGR(dsn = "Shapefile",
                        layer="infuse_cnty_lyr_2011")
uk_county_coord

wgs84 = '+proj=longlat +datum=WGS84'
uk_county_latLong = spTransform(uk_county_coord, CRS(wgs84))
uk_county_latLong
plot(uk_county_latLong, cex=2.5)


coord_narm = subset(coordinates, is.na(coordinates$Longitude)==FALSE)
coord_narm = subset(coord_narm, is.na(coord_narm$Latitude)==FALSE)
coordinates(coord_narm) = ~Longitude+Latitude
proj4string(coord_narm) = proj4string(uk_county_latLong)
#plot(uk_county_latLong, cex=2.5)

overlay = over(coord_narm, uk_county_latLong)
head(overlay)








# Sources:
# Boundary Data: https://borders.ukdataservice.ac.uk/easy_download_data.html?data=infuse_cnty_lyr_2011
# Spatial file read: https://www.zevross.com/blog/2016/01/13/tips-for-reading-spatial-files-into-r-with-rgdal/
# using data: https://blog.exploratory.io/making-maps-for-uk-countries-and-local-authorities-areas-in-r-b7d222939597
# map overlay: https://stackoverflow.com/questions/24174042/matching-georeferenced-data-with-shape-file-in-r
# tableau geocode: https://interworks.com/blog/ktreadwell/2012/11/01/adding-custom-geocoding-tableau/
