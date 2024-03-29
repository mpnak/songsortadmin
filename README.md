Stationdose//Songsort
===================

A Ruby on Rails application serving up the Stationdose API.

## QuickStart

In the console

```
// Install project ruby gems
bundle install

// Create the database
bundle exec rake db:create

// Run migrations
bundle exec rake db:migrate

// Run tests
bundle exec rspec

// Load development data
bundle exec rake db:data:load

// Start the server
bundle exec rails s

```
Now you are good to go. Open `http://localhost:3000` in a browser to test the endpoints

## Endpoints


### Spotify token swap/refresh

```
POST /api/spotify/swap
```

```
POST /api/spotify/refresh
```

Create a Stationdose session
```
POST /api/spotify/sessions
required params:
  access_token (a valid Spotify access_token)

example response:
{
  "user": {
    "id": 5,
    "auth_token": "nP1ZzmGUsd3eNKnB5mYUgq83sRE="
  }
}
```

### Stations

List all stations.
```
GET /api/stations

query for station_type:
GET /api/stations?station_type=standard
GET /api/stations?station_type=featured
GET /api/stations?station_type=sponsored
```

Generate tracks
```
POST /api/stations/:station_id/tracks
params:
  ll // (optional) location string in the format "latitude,longitude" e.g. "37.1,45.63"
  name // (optional) the name of the energy profile e.g. "mellow". If name is supplied it will ignore the ll paramater and short cut to using the name
  undergroundness // (optional) if supplied, the users undergroundness setting will be updated
```

Read existing tracks
```
GET /api/stations/:station_id/tracks
params:
```

Station art
```
a url hosting the station art image is returned in the station json response
```

Update
```
PUT /api/stations/:station_id
example data:
{
  station: {
    undergroundness: 3
  }
}
```

Get the energy profile
```
GET /api/stations/playlist_profile_chooser
params:
  ll // e.g. "37.1,45.63"
example data:
{
  "playlist_profile_chooser": {
    "name": "club",
    "weather": "partly-cloudy-day",
    "localtime": "2016-04-29T16:14:17+03:00",
    "day": 5,
    "all_names": [
      "mellow",
      "chill",
      "vibes",
      "lounge",
      "club",
      "bangin"
    ],
    "timezone": "Europe/Kiev"
  }
}
```

### Saved Stations

list a users saved stations
```
GET /api/stations?saved_station=true
```

Save a station
```
PUT /api/station/:station_id
example data:
{
  station: {
    saved_station: true // or "1"
  }
}
```

Unsave a station
```
PUT /api/station/:station_id
example data:
{
  station: {
    saved_station: false // or "0"
  }
}
```

### Tracks

track is played, skipped, favorited or banned
```
POST /api/tracks/:track_id/play
POST /api/tracks/:track_id/skipped
POST /api/tracks/:track_id/favorited
POST /api/tracks/:track_id/unfavorited
POST /api/tracks/:track_id/banned

required params:
  station_id
```
