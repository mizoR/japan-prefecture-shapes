FROM postgres:15-alpine

ENV POSTGRES_DB db

ENV POSTGRES_USER app

ENV POSTGRES_PASSWORD password

ENV POSTGIS_VERSION 3.3.2

RUN apk --update add wget make unzip binutils gcc cmake g++ perl-data-dump \
      libxml2-dev geos-dev proj-dev protobuf-c-dev gdal-dev clang llvm

RUN wget --no-check-certificate https://download.osgeo.org/postgis/source/postgis-$POSTGIS_VERSION.tar.gz \
      && tar xvzf postgis-$POSTGIS_VERSION.tar.gz

RUN cd postgis-$POSTGIS_VERSION \
      && ./configure \
      && make \
      && make install \
      && cd ../.. \
      && rm -Rf postgis-$PGROUTING_VERSION \
      && rm postgis-$POSTGIS_VERSION.tar.gz

RUN mkdir -p docker-entrypoint-initdb.d/

COPY docker-entrypoint-initdb.d/init.sh docker-entrypoint-initdb.d/
