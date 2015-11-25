FactoryGirl.define do
  factory :playlist do
    user
    station
    undergroundness 3
    use_weather true
    use_timeofday true
    autoupdate true
  end

end
