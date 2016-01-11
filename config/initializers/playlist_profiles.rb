PLAYLIST_PROFILES ||= {}.with_indifferent_access

Dir["#{Rails.root}/config/playlist_profiles/*.yml"].each do |file|
  data = YAML.load_file(file)
  PLAYLIST_PROFILES.merge!(data)
end
