FROM postgres:15-alpine

ENV POSTGRES_DB db

ENV POSTGIS_VERSION 3.3.2

RUN apk --update add wget make unzip binutils gcc cmake

RUN apk add g++

RUN wget --no-check-certificate https://download.osgeo.org/postgis/source/postgis-$POSTGIS_VERSION.tar.gz \
      && tar xvzf postgis-$POSTGIS_VERSION.tar.gz

RUN apk add perl-data-dump libxml2-dev geos-dev proj-dev
# RUN apk add protoc protobuf-c-compiler protobuf-dev
RUN apk add protobuf-c-dev gdal-dev clang
RUN apk add llvm

RUN cd postgis-$POSTGIS_VERSION \
      && ./configure

RUN cd postgis-$POSTGIS_VERSION \
      && make \
      && make install \
      && cd ../.. \
      && rm -Rf postgis-$PGROUTING_VERSION \
      && rm postgis-$POSTGIS_VERSION.tar.gz

ENV POSTGRES_USER app
ENV POSTGRES_PASSWORD password

RUN mkdir -p docker-entrypoint-initdb.d/
COPY docker-entrypoint-initdb.d/init.sh docker-entrypoint-initdb.d/
