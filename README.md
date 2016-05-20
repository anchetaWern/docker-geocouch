# Dockerized GeoCouch

Dockeried CouchdDB 1.6.1 with GeoCouch.


# Build and start the container

```
git clone git@github.com:elecnix/docker-geocouch.git
cd docker-geocouch
docker build -t elecnix/docker-geocouch:1.6.1 .
```

After the build is complete, the container can be either created adn started
```
docker create -ti -p 5984:5984 elecnix/docker-geocouch:1.6.1
docker start <continer id>
``` 

...or created and run directly, opening a BASH shell within the container itself
```docker run -ti -p 5984:5984 elecnix/docker-geocouch:1.6.1```


# Notes
* Exposes couchdb on port `5984` of the container
* Euns everything as user `couchdb` (security ftw!)
* Couchdb is run as a service
* No user is set in CouchDB (welcome to the admin party!)



