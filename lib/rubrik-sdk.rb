require 'net/http'
require 'logger'
require 'base64'
require 'json'

$logger = Logger.new(STDOUT)

class Cluster
    def self.getSoftwareVersion(clusterName)
        # No Auth required
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")

        uristring = "https://" + clusterName + "/api/v1/cluster/me/version"
       
        uri = URI.parse(uristring)
        $logger.debug("URI used: " + uri.to_s)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        result = http.get(uri.request_uri)
        $logger.debug("HTTP status code: " + result.code)
        
        puts result.response.body
    end
end