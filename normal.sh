#!/usr/bin/env bash
set -x
set -e
set -o pipefail

function memsize() {
    # total physical memory in MB
    case "$(uname -s)" in
        'Linux')    echo $(($(free | awk '/^Mem:/{print $2}')/1024));;
        'Darwin')   echo $(($(sysctl -n hw.memsize)/1024/1024));;
        *)          echo 1;;
    esac
}

function nprocs() {
    # number of processors on the current system
    case "$(uname -s)" in
        'Linux')    nproc;;
        'Darwin')   sysctl -n hw.ncpu;;
        *)          echo 1;;
    esac
}

wm=$(( `memsize` / (`nprocs`+1) ))

aws s3 sync s3://mapbox-ljbade/nzdem .
gdaldem slope -s 8 -compute_edges dem.vrt slope.tif
gdaldem aspect -s 8 -compute_edges -zero_for_flat dem.vrt aspect.tif
rm dem.vrt
rm -r extracted
gdal_calc.py -A slope.tif -B aspect.tif --outfile=x.tif --calc="sin(radians(A))*sin(radians(B))" --debug
gdal_calc.py -A slope.tif -B aspect.tif --outfile=y.tif --calc="sin(radians(A))*cos(radians(B))" --debug
gdal_calc.py -A slope.tif --outfile=z.tif --calc="cos(radians(A))" --debug
rm slope.tif
rm aspect.tif
gdalbuildvrt -separate xyz.vrt x.tif y.tif z.tif
gdal_translate -ot Byte -scale_1 -1.0 1.0 0 255 -scale_2 -1.0 1.0 0 255 -scale_3 0.0 1.0 0 255 xyz.vrt normal.tif
rm xyz.vrt x.tif y.tif z.tif
gdalwarp -t_srs epsg:3785 -r bilinear --config GDAL_CACHEMAX $wm -wm $wm -multi -wo NUM_THREADS=ALL_CPUS normal.tif normal-3785-2.tif
rm normal.tif
