class TrackSerializer < ActiveModel::Serializer
  attributes :id, :spotify_id, :echo_nest_id, :title, :artist, :undergroundness
end
