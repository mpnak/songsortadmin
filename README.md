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
bundle exec rake db:seed

// Start the server
bundle exec rails s

```
Now you are good to go. Open `http://localhost:3000` in a browser to test the endpoints

## Endpoints

### Stations

List all stations.
```
GET /stations
```

Station image
```
GET /stations/:station_id/image
```

### Playlists

list a users playlists
```
GET users/:user_id/playlists
```

Read
```
GET users/:user_id/playlists/:playlist_id
```

Create
```
POST users/:user_id/playlists/
```

Update
```
PUT users/:user_id/playlists/:playlist_id
```

Delete
```
DELETE users/:user_id/playlists/:playlist_id
```

### Tracks

track is played, skipped, favorited or banned
```
POST /users/:user_id/playlists/:playlist_id/tracks/:track_id/play
POST /users/:user_id/playlists/:playlist_id/tracks/:track_id/skipped
POST /users/:user_id/playlists/:playlist_id/tracks/:track_id/favorited
POST /users/:user_id/playlists/:playlist_id/tracks/:track_id/banned
```
