## ----prep, echo=FALSE-------------------------------------------------------------------------
library(dssd)
shapefile.name <- system.file("extdata", "StAndrew.shp", package = "dssd")
region <- make.region(region.name = "St Andrews Bay",
                      units = "m",
                      shape = shapefile.name)
cover <- make.coverage(region, n.grid.points = 500)


## ----designspacingsol, eval=TRUE--------------------------------------------------------------
# Define the design
design.space500 <- make.design(region = region,
                      transect.type = "line",
                      design = "systematic",
                      spacing = 5000,
                      design.angle = 90,
                      edge.protocol = "minus",
                      truncation = 2000,
                      coverage.grid = cover)


## ----designspacingsol2, eval=TRUE, message=FALSE, fig.cap="Coverage grid plot for parallel design.", fig.width=5, fig.height=5----
# Run the coverage simulation
design.space500 <- run.coverage(design.space500, reps = 100, quiet=TRUE)
plot(design.space500)


## ----designspacingsol3, eval=TRUE-------------------------------------------------------------
# Display the design statistics
design.space500


## ----prep2------------------------------------------------------------------------------------
design.zz.4500 <- make.design(region = region,
                      transect.type = "line",
                      design = "eszigzag",
                      spacing = 4500,
                      design.angle = 0,
                      edge.protocol = "minus",
                      bounding.shape = "convex.hull",
                      truncation = 2000,
                      coverage.grid = cover)


## ----zzcoveragesol, eval = TRUE,  fig.cap="Coverage grid plot for zigzag design.", fig.width=5, fig.height=5----
# Run coverage simulation
design.zz.4500 <- run.coverage(design.zz.4500, reps = 100, quiet=TRUE)
# Plot coverage
plot(design.zz.4500)


## ----zzcoveragesol3, eval = TRUE, echo = FALSE------------------------------------------------
# Display design statistics
design.zz.4500


## ----prep3, echo=FALSE, include=FALSE---------------------------------------------------------
library(sf)
shapefile.name <- system.file("extdata", "TentsmuirUnproj.shp", package = "dssd")
sf.shape <- read_sf(shapefile.name)
st_crs(sf.shape)
proj4string <- "+proj=aea +lat_1=56 +lat_2=62 +lat_0=50 +lon_0=-3 +x_0=0 
                +y_0=0 +ellps=intl +units=m"
projected.shape <- st_transform(sf.shape, crs = proj4string)
region.tm <- make.region(region.name = "Tentsmuir",
                         strata.name = c("Main Area", "Morton Lochs"),
                         shape = projected.shape)


## ----coveragegridtm---------------------------------------------------------------------------
# Set up coverage grid, with lots of grid points
#     This many grid points will slow down execution of this code;
#     I used this resolution to see fine detail in the plots for demonstration
#     If you adapt this code for your use, you may wish to initially reduce points
cover.tm <- make.coverage(region.tm, n.grid.points = 500)
design.tm <- make.design(region = region.tm,
                         transect.type = "point",
                         design = "systematic",
                         samplers = c(25,15),
                         design.angle = 0,
                         edge.protocol = "minus",
                         truncation = 100,
                         coverage.grid = cover.tm)
survey.tm <- generate.transects(design.tm)


## ----surveytmsols-----------------------------------------------------------------------------
survey.tm


## ----designtmsols2----------------------------------------------------------------------------
sims.tm <- run.coverage(design.tm, reps=100, quiet=TRUE)
sims.tm


## ----fig1, echo=FALSE, fig.cap="Coverage scores for each strata for the point transect Tentsmuir Forest survey design.",  fig.align='center'----
plot(sims.tm, strata.id=1, subtitle="Main area")
plot(sims.tm, strata.id=2, subtitle="Morton Lochs")

