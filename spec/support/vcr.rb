VCR.configure do |c|
  # the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service.
  c.hook_into(:webmock)
end

RSpec.configure do |c|
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(%r{[^\w/]+}, '_')
    VCR.use_cassette(name, allow_playback_repeats: true) { example.call }
  end
end
