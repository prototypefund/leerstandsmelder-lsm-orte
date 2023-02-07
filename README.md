 [![pipeline status](https://gitlab.com/leerstandsmelder/lsm-orte/badges/main/pipeline.svg)](https://gitlab.com/leerstandsmelder/lsm-orte/-/commits/main) [![coverage report](https://gitlab.com/leerstandsmelder/lsm-orte/badges/main/coverage.svg)](https://gitlab.com/leerstandsmelder/lsm-orte/-/commits/main) [![Latest Release](https://gitlab.com/leerstandsmelder/lsm-orte/-/badges/release.svg)](https://gitlab.com/leerstandsmelder/lsm-orte/-/releases)


# LSM-ORTE / ORTE-backend

Backend application for creating and managing places/POIs (or in german "Orte"),  formatted text and assets like images, audio and video on a web-based map. Additionally relations between places can be set. Output is a public available API w/JSON or exportable as CSV/JSON/GeoJSON data. It has also some extra features like visualising relations between places and a map to go feature (see below).

This is a fork of [ORTE-backend](https://github.com/a-thousand-channels/ORTE-backend/) for LSM23/leerstandsmelder.de relaunch project.

Based on Ruby on Rails 6, Postgres, jQuery, Leaflet and Foundation 6.

Contributions to this application are appreciated (see below).

<img src="https://gitlab.com/leerstandsmelder/lsm-orte/-/raw/main/app/assets/images/ORTE-sample-map2-overview.jpg" style="max-width: 640px" width="640" />

## Address and geolocation lookup

This application uses [Nominatim](https://nominatim.openstreetmap.org/), a search engine for OpenStreetMap data to look up address and geolocation data. By implementing this application you should respect the [Nominatim Usage Policy](https://operations.osmfoundation.org/policies/nominatim/)!


## Installation

Basic steps for a local installation on your machine:

### Requirements

* Webserver (e.g. Apache or NGINX)
* Ruby 2.7+, RVM, Rubygems
* Postgres DB
* ffmpeg (for the video feature), ImageMagick (for the image feature)
* Redis

### Get repository

```bash
$ git clone git@gitlab.com:leerstandsmelder/lsm-orte.git
```
### Prepare Rails

```bash
$ gem install bundler
$ bundle install
```

### Setup Postgres DB

```bash
$ psql postgres
postgres=# CREATE ROLE lsm_orte WITH LOGIN PASSWORD 'lsm_orte00';
postgres=# ALTER ROLE kok CREATEDB; 
postgres=# CREATE DATABASE lsm_orte_development;
postgres=# GRANT ALL PRIVILEGES ON DATABASE lsm_orte_development TO lsm_orte;
postgres=# exit;
$ bundle exec rails db:schema:load
$ bundle exec rails db:seed
```

### Enviroments variables

Some settings (like database setup) you'll need for productive installation on a server are stored in the enviroment file (.env).


### Credentials

Some settings (like email settings or database setup) you'll need for productive installation on a server are stored in the credential file.

Edit the credential file with

```bash
$ EDITOR=vim bundle exec rails credentials:edit
```

All used and needed variables are explained in the credentials.yml.default file.

To use this in different environments, with development and installations for staging or production server you can use the multi-environment credentials that came with Rails 6.1.

To create/edit a specific credential file for staging use:

```bash
$ EDITOR=vim bundle exec rails credentials:edit --environment staging
```

For details on this technique please read this good explainer about [credentials in Rails 6.1](https://blog.saeloun.com/2019/10/10/rails-6-adds-support-for-multi-environment-credentials.html)

### Optional: Mapbox Token for satellite imagery

As a default at ORTE, satellite imagery is used as a base layer. This imagery is available only up to level 18. If you want to have satellite imagery on a higher zoom level (19-21), where you can more clearly see details on streets, places and buildings, than you have to define an additional satellite imagery provider. ORTE has as a preset for Mapbox satellite imagery, but to use it, you need to have a Mapbox account and to generate a Mapbox API Token. (Of course this completely optional, and you switch on user level or permant on map level to a OSM base map.)

You can define your mapbox token in the credentials (token[:mapbox])

### Run application locally

```bash
$ bundle exec rails s
```

### Test applocation locally


```bash
$ RAILS_ENV=test bundle exec rails db:migrate
$ RAILS_ENV=test COVERAGE=true bundle exec rspec spec
```

### Build a docker image

You can build a docker image from the repository.

```bash
$ docker build -t [TAG_DOCKER_IMAGE] .
```


## Credits

* [A thousand channels](https://www.a-thousand-channels.xyz/), initiated by [Ulf Treger](https://github.com/ut)

## Feedback & Contributions

Feedback, bug reports and code contributions are most welcome.

Send Feedback to lsm23@leerstandsmelder.de

Please file bug reports and feature request to our Gitlab Repository at https://gitlab.com/leerstandsmelder/lsm-orte/-/issues/new

For code contributions, please fork this repo, make a branch, commit your code & [create a merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html).

All contributors shall respect the [Contributor Covenant Code of Conduct](https://gitlab.com/leerstandsmelder/lsm-orte/-/raw/main/CODE_OF_CONDUCT.md)


## Licence

This project is licensed under a [GNU General Public Licence v3](https://gitlab.com/leerstandsmelder/lsm-orte/-/raw/main/LICENSE)
