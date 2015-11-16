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

### Stations

List all stations.
```
GET /api/stations
```

Station image
```
GET /api/stations/:station_id/image
```

### Playlists

list a users playlists
```
GET /api/users/:user_id/playlists
```

Read
```
GET /api/users/:user_id/playlists/:playlist_id
```

Create
```
POST /api/users/:user_id/playlists/
```

Update
```
PUT /api/users/:user_id/playlists/:playlist_id
```

Delete
```
DELETE /api/users/:user_id/playlists/:playlist_id
```

### Tracks

track is played, skipped, favorited or banned
```
POST /api/users/:user_id/playlists/:playlist_id/tracks/:track_id/play
POST /api/users/:user_id/playlists/:playlist_id/tracks/:track_id/skipped
POST /api/users/:user_id/playlists/:playlist_id/tracks/:track_id/favorited
POST /api/users/:user_id/playlists/:playlist_id/tracks/:track_id/banned
```
