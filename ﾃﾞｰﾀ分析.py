from shapely.geometry import Point,LineString,Polygon,MultiPoint,MultiLineString,MultiPolygon,GeometryCollection
import folium
point1=Point(135.758,34.985)
point2=Point(135.729,35.039)
point3=Point(135.746,35.066)
point4=Point(135.798,35.027)
multip=MultiPoint([point1,point2,point3,point4])

print(point1)
print(multip)

center=multip.centroid
map=folium.Map(location=[center.y,center.x],zoom_start=12)
folium.Marker([center.y,center.x],icon=folium.Icon(color='red')).add_to(map)
folium.GeoJson(multip).add_to(map)
map
