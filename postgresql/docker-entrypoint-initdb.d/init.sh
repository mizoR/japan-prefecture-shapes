psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE EXTENSION postgis"

mkdir /tmp/work

pushd /tmp/work

wget https://nlftp.mlit.go.jp/ksj/gml/data/N03/N03-2017/N03-170101_GML.zip

unzip N03-170101_GML.zip

shp2pgsql -I -W latin1 -s 4326 *.shp temp_prefectures | psql -U $POSTGRES_USER -d $POSTGRES_DB

psql -U $POSTGRES_USER -d $POSTGRES_DB << EOF
CREATE TABLE prefectures (id character varying NOT NULL, geometry geometry(MultiPolygon, 4326) NOT NULL);

INSERT INTO prefectures (id, geometry)
  SELECT id, geometry FROM (SELECT ST_Multi(ST_Union(geom)) AS geometry, n03_001 AS id FROM temp_prefectures GROUP BY n03_001) prefectures;

EOF
# DROP TABLE temp_prefectures;


popd

rm -rf /tmp/work
