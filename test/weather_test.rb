require 'test_helper'

describe Weather do
  it 'has a version number' do
    refute_nil Weather::VERSION
  end
end

describe Weather::Gateway do
  before do
    app_id = ENV['WEATHER_APP_ID']
    abort "set WEATHER_APP_ID env variable" unless app_id
    @gateway = Weather::Gateway.new(app_id)
  end

  it 'gets forecast for New York' do
    samples = @gateway.forecast('New York')

    assert samples.any?
    samples.each do |sample|
      assert_respond_to sample, :date
      assert_respond_to sample, :description
      assert_respond_to sample, :humidity
      assert_respond_to sample, :temp_min
      assert_respond_to sample, :temp_max
    end
  end
end
