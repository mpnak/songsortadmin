class PlaylistProfileChooserSerializer < ActiveModel::Serializer
  attributes :name, :weather, :localtime, :day, :all_names, :timezone
end
