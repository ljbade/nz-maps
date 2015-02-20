@land: white;
@water: cornflowerblue;
@water-fill: lightblue;
@contours: darkorange;

#ljbade_62e96a51 {
  raster-opacity: 1;
}

#island_polygons {
  /*polygon-fill: @land;*/
}

#scrub_polygons, 
/*#scattered_scrub_polygons*/ {
  polygon-fill: lightgreen;
  line-color: green;
  line-width: 1;
  polygon-opacity: 0.5;
  line-opacity: 0.5;
}

#exotic_polygons {
  polygon-fill: yellowgreen;
  line-color: forestgreen;
  line-width: 1;
  polygon-opacity: 0.5;
  line-opacity: 0.5;
}

#native_polygons {
  polygon-fill: darkseagreen;
  line-color: seagreen;
  line-width: 1;
  polygon-opacity: 0.5;
  line-opacity: 0.5;
}

#reservoir_polygons,
#lagoon_polygons,
#rapid_polygons,
#river_polygons,
#lake_polygons,
#pond_polygons,
#canal_polygons,
#waterfall_polygons {
  polygon-fill: @water-fill;
  line-color: @water;
  line-width: 1;
}

#river_centrelines,
#water_race_centrelines,
#canal_centrelines  {
  line-color: @water;
  line-width: 1;
}

#coastlines,
#island_polygons {
  line-color: @water;
  line-width: 1;
}

/*#cliff_edges {
  line-color: black;
  line-width: 0.5;
}*/

#track_centrelines {
  line-color: black;
  line-width: 2;

  [track_use='foot'] {
    line-dasharray: 8,4;
  }

  [status='closed'] {
    line-dasharray: 8,8;
  }
  
  [track_type='poled route'] {
    line-dasharray: 1,6;
    line-cap: round;
  }

  [track_use='vehicle'] {
    line-dasharray: 20,4;
  }
}

#road_centrelines::edge {
  line-color: black;

  [lane_count=1] {
    line-width: 4;
  }
  
  [lane_count=2] {
    line-width: 5;
  }
  
  [lane_count>2] {
    line-width: 6;
  }
}

#road_centrelines::centre {
  line-color: @contours;
  
  [surface='unmetalled'] {
    line-color: white;
  }
  
  [hway_num!=''] {
    line-color: crimson;
  }

  [lane_count=1] {
    line-width: 2;
  }
  
  [lane_count=2] {
    line-width: 3;
  }
  
  [lane_count>2] {
    line-width: 4;
  }
}

#road_centrelines::dash[surface='metalled'] {
  line-color: white;
  line-dasharray: 8,20;

  [lane_count=1] {
    line-width: 2;
  }
  
  [lane_count=2] {
    line-width: 3;
  }
  
  [lane_count>2] {
    line-width: 4;
  }
}

/*#height_points {
  marker-fill: black;
  marker-width: 2;
}*/

#contours {
  [zoom>13] {
    line-color: @contours;
    line-width: 0.5;
    line-opacity: 0.5;
  }
  
  [elevation=100],
  [elevation=200],
  [elevation=300],
  [elevation=400],
  [elevation=500],
  [elevation=600],
  [elevation=700],
  [elevation=800],
  [elevation=900],
  [elevation=1000],
  [elevation=1100],
  [elevation=1200],
  [elevation=1300],
  [elevation=1400],
  [elevation=1500],
  [elevation=1600],
  [elevation=1700],
  [elevation=1800],
  [elevation=1900],
  [elevation=2000],
  [elevation=2100],
  [elevation=2200],
  [elevation=2300],
  [elevation=2400],
  [elevation=2500],
  [elevation=2600],
  [elevation=2700],
  [elevation=2800],
  [elevation=2900],
  [elevation=3000],
  [elevation=3100],
  [elevation=3200],
  [elevation=3300],
  [elevation=3400],
  [elevation=3500],
  [elevation=3600],
  [elevation=3700] {
    line-color: @contours;
    line-width: 1;
    line-opacity: 0.5;
    //text-name: [elevation];
    //text-face-name: 'Clan Offc Pro Narrow News Italic';
    //text-fill: @contours;
    //text-placement: line;
    //text-halo-fill: @land;
    //text-halo-radius: 2;
  }
}

Map {
  background-color: @land;
}