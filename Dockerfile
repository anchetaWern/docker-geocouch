FROM klaemo/couchdb-base

MAINTAINER Clemens Stolle klaemo@fastmail.fm + Jon Richter post@jonrichter.de

ENV COUCH_VERSION 1.6.1 
ENV COUCH_HOME /opt/apache-couchdb-${COUCH_VERSION}/
ENV COUCH_SRC ${COUCH_HOME}src/couchdb
ENV GEOCOUCH_SRC /opt/geocouch/
ENV GEOCOUCH_BIN ${GEOCOUCH_SRC}gc-couchdb/ebin/
ENV GEOCOUCH_INI ${GEOCOUCH_SRC}gc-couchdb/etc/couchdb/default.d/
ENV ERL_LIB_HOME /usr/local/lib/couchdb/erlang/lib

# Install unzip and git after the customary update
RUN apt-get update && apt-get install -y unzip git

# Install github.com/visionmedia/mon v1.2.3
RUN (mkdir /tmp/mon && cd /tmp/mon && curl -L# https://github.com/visionmedia/mon/archive/1.2.3.tar.gz | tar zx --strip 1 && make install)

# Get the CouchDB source
RUN cd /opt; wget http://apache.openmirror.de/couchdb/source/${COUCH_VERSION}/apache-couchdb-${COUCH_VERSION}.tar.gz && \
    tar xzf /opt/apache-couchdb-${COUCH_VERSION}.tar.gz

# Build CouchDB
RUN cd ${COUCH_HOME} && ./configure && make dev && make install

# Get the GeoCouch source with the "MB-15975: Always find a split candidate" issue fixed
RUN cd /opt; git clone -b newvtree-fix-split-candidates https://github.com/vmx/geocouch.git

# Build GeoCouch
RUN cd ${GEOCOUCH_SRC}; make couchdb

# Copy the GeoCouch libraries to the CouchDB installation
RUN cp -r ${GEOCOUCH_SRC}gc-couchdb/ ${ERL_LIB_HOME} &&\
    cp -r ${GEOCOUCH_SRC}vtree/ ${ERL_LIB_HOME}

# Configuration
ADD ./opt /opt
RUN sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i /usr/local/etc/couchdb/default.ini
RUN /opt/couchdb-config

# Define mountable directories.
VOLUME ["/usr/local/var/log/couchdb", "/usr/local/var/lib/couchdb", "/usr/local/etc/couchdb", "${COUCH_HOME}", "${GEOCOUCH_SRC}"]

ENTRYPOINT /opt/start_couch && /bin/bash
EXPOSE 5984