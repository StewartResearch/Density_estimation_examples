# live-intro-6-design
Survey design for St Andrews Bay and Tentsmuir using dssd

Study area shape file was rebuilt for purposes of figure 1 in practical.  This is because the shape file associated with `dssd` has no CRS.

I created my own study area shape file (to be projected using `leaflet`) by downloading a GB coastline shape file from http://www.diva-gis.org/gdata, then
creating a second shape file by hand in QGIS and "differencing" them.  Result is shape file `nicerarea.shp` that resembles the original, but has CRS with degrees, such that `leaflet` can plot it.
