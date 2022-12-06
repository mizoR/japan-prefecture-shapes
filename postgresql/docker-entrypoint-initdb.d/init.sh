psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE EXTENSION postgis"

mkdir /tmp/work

pushd /tmp/work

wget https://nlftp.mlit.go.jp/ksj/gml/data/N03/N03-2017/N03-170101_GML.zip

unzip N03-170101_GML.zip

shp2pgsql -I -W latin1 -s 4326 *.shp temp_prefectures | psql -U $POSTGRES_USER -d $POSTGRES_DB

psql -U $POSTGRES_USER -d $POSTGRES_DB << EOF
CREATE TABLE prefecture_shapes (code char(2) NOT NULL, geom geometry(MultiPolygon, 4326) NOT NULL);

INSERT INTO prefecture_shapes (code, geom)
  SELECT code, geom FROM (
    SELECT ST_Multi(ST_Union(geom)) AS geom, LEFT(n03_007, 2) AS code
    FROM temp_prefectures
    WHERE n03_007 IS NOT NULL
    GROUP BY LEFT(n03_007, 2)
  ) prefecture_shapes;

DROP TABLE temp_prefectures;
EOF
popd

rm -rf /tmp/work
