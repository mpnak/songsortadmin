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
pass in a user_id to get back a favorited flag for each track
```

Station art
```
a url hosting the station art image is returned in the station json response
```

### Saved Stations

list a users playlists
```
GET /api/users/:user_id/saved_stations
```

Read
```
GET /api/saved_stations/:saved_station_id
```

Create
```
POST /api/users/:user_id/saved_stations/
example data:
{
  saved_station: {
    user_id: 1 (required),
    station_id: 1 (required)
    undergroundness: 2 (optional),
    use_weather: true (optional),
    use_timeofday: true (optional),
    autoupdate: true (optional)
  }
}
```

Update
```
PUT /api/saved_stations/:saved_station_id
example data:
{
  saved_station: {
    undergroundness: 3
  }
}
```

Delete
```
DELETE /api/saved_stations/:saved_station_id
```

Generate new tracks
```
POST /api/saved_stations/:saved_station_id/tracks
pass in a user_id to get back a favorited flag for each track
```

Read existing tracks
```
GET /api/saved_stations/:saved_station_id/tracks
pass in a user_id to get back a favorited flag for each track
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
  user_id
  station_id
  saved_station_id (if there is one, this will remove the track from the saved
stations existing tracks)
```
