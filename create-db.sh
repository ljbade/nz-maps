#!/usr/bin/env bash

#sudo apt-get install postgresql-9.3 postgresql-9.3-postgis-2.1 postgresql-client-9.3

#USER=leith
USER=postgres
DATABASE=nztopo50

#sudo -u postgres createuser $USER
#sudo -u postgres createdb -O $USER $DATABASE
#sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" $DATABASE

export PGHOST=localhost
#export PGPORT=
export PGDATABASE=$DATABASE
export PGUSER=$USER
#export PGPASSWORD=

createdb -T template_postgis $DATABASE
psql -f $APP_DIR/node_modules/postgis-vt-util/lib.sql
#psql -c "CREATE SCHEMA nztm;"

mkdir /mnt/data/nztopo50
cd /mnt/data/nztopo50
aws s3 cp --region=ap-southeast-2 s3://mapbox-ljbade/nz-topo-50/lds-new-zealand-141layers-SHP.zip .
unzip lds-new-zealand-141layers-SHP.zip
rm lds-new-zealand-141layers-SHP.zip

echo "attribution: ''
center: 
  - 15.1757
  - 45.1734
  - 12
description: ''
Layer: " >> data.yml

for LAYER in `find . ! -path . -type d | sort`
do
    NAME=${LAYER#./nz-mainland-}
    NAME=${NAME%-topo-150k}
    NAME=${NAME//-/_}

    shp2pgsql -c -s 2193:3857 -I -S -i $LAYER/$LAYER.shp $NAME | psql
    
    #shp2pgsql -c -s 2193:3857 -I -S -i nz-mainland-contours-topo-150k-22.shp contours | psql && shp2pgsql -a -s 2193:3857 -S -i nz-mainland-contours-topo-150k-23.shp contours | psql && shp2pgsql -a -s 2193:3857 -S -i nz-mainland-contours-topo-150k-24.shp contours | psql && shp2pgsql -a -s 2193:3857 -S -i nz-mainland-contours-topo-150k-25.shp contours | psql
    
    #alter table $table_name add column geom_3857;
    #update $table_name set geom_3857 = st_transform(geom, 3857);
    
    # TODO: detect layers that need to be multipolygons and drop -S - only 1 layer so far - shingle polygons
    # handle multipart contours data
    
    echo "  - id: $NAME
    Datasource: 
      dbname: nztopo50
      extent: -20037508.34,-20037508.34,20037508.34,20037508.34
      geometry_field: ''
      geometry_table: ''
      host: ''
      key_field: ''
      max_size: 512
      password: ''
      port: ''
      table: |
        ( SELECT *
          FROM $NAME
        ) AS data
      type: postgis
      user: postgres
    description: ''
    fields: {}
    properties: 
      \"buffer-size\": 8
    srs: +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over"  >> data.yml
done


echo "maxzoom: 14
minzoom: 12
name: 'nztopo50'" >> data.yml

cd ~

#git clone https://github.com/mapbox/mapbox-studio.git
#cd mapbox-studio
#npm install
#npm start

wget https://mapbox.s3.amazonaws.com/mapbox-studio/mapbox-studio-linux-x64-v0.2.4.zip
unzip mapbox-studio-linux-x64-v0.2.4.zip
cd mapbox-studio-linux-x64-v0.2.4/resources/app
./index.js

