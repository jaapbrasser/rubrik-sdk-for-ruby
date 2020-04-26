Gem::Specification.new do |spec|

    spec.name          = 'rubrik-sdk'
    spec.version       = File.read(File.expand_path('../VERSION', __FILE__)).strip
    spec.summary       = 'Rubrik SDK for Ruby'
    spec.description   = 'The official Rubrik SDK for Ruby. Provides both resource oriented interfaces and API clients for Rubrik services.'
    spec.author        = 'Jaap Brasser'
    spec.homepage      = 'https://github.com/rubrikinc/rubrik-sdk-for-ruby'
    spec.license       = 'MIT'
    spec.email         = ['build@rubrik.com']
    spec.files         = Dir['lib/**/*.rb']


    #spec.metadata = {
    #  'source_code_uri' => 'https://github.com/rubrikinc/rubrik-sdk-for-ruby/tree/master/rubrik-sdk',
    #  'changelog_uri'   => 'https://github.com/rubrikinc/rubrik-sdk-for-ruby/tree/master/rubrik-sdk/CHANGELOG.md'
    #}
end