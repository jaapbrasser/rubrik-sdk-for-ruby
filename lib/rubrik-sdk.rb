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

    def self.getApiVersion(clusterName)
        # No Auth required
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")
        uristring = "https://" + clusterName + "/api/v1/cluster/me/api_version"
       
        uri = URI.parse(uristring)
        $logger.debug("URI used: " + uri.to_s)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        result = http.get(uri.request_uri)
        $logger.debug("HTTP status code: " + result.code)
        
        puts result.response.body
    end

    def self.getClusterInfo()
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")

        if defined?($rubrikConnection)
            uristring = "https://#{$rubrikConnection['clusterName']}/api/v1/cluster/me"
            
            uri = URI.parse(uristring)
            $logger.debug("URI used: " + uri.to_s)

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            
            header = {}
            header['Authorization'] = "Bearer #{$rubrikConnection['token']}"

            result = http.get(uri.request_uri, header)
            $logger.debug("HTTP status code: " + result.code)
            
            puts result.response.body
        else
            $logger.error("Not authenticated, the #{__method__.to_s} method requires you to authenticate to the Rubrik cluster first")
        end
    end
end

class VMware_VM
    def self.getVM(clusterName,name)
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")
        if defined?($rubrikConnection)
            uristring = "https://#{$rubrikConnection['clusterName']}/api/v1/cluster/me"
            
            uri = URI.parse(uristring)
            params = { :name => "#{name.to_s}", :primary_cluster_id => 'local'}
            uri.query = URI.encode_www_form(params)

            $logger.debug("URI used: " + uri.to_s)

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            
            header = {}
            header['Authorization'] = "Bearer #{$rubrikConnection['token']}"

            result = http.get(uri.request_uri, header)
            $logger.debug("HTTP status code: " + result.code)
            
            puts result.response.body
        else
            $logger.error("Not authenticated, the #{__method__.to_s} method requires you to authenticate to the Rubrik cluster first")
        end
    end
end

class SlaDomain
    def self.getSLA(name:)
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")
        if defined?($rubrikConnection)
            uristring = "https://#{$rubrikConnection['clusterName']}/api/v2/sla_domain"
            
            uri = URI.parse(uristring)
            params = { :name => "#{name.to_s}", :primary_cluster_id => 'local'}
            uri.query = URI.encode_www_form(params)

            $logger.debug("URI used: " + uri.to_s)

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            
            header = {}
            header['Authorization'] = "Bearer #{$rubrikConnection['token']}"

            result = http.get(uri.request_uri, header)
            $logger.debug("HTTP status code: " + result.code)
            
            puts result.response.body
        else
            $logger.error("Not authenticated, the #{__method__.to_s} method requires you to authenticate to the Rubrik cluster first")
        end
    end

    def self.deleteSLA(id:)
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")
        if defined?($rubrikConnection)
            uristring = "https://#{$rubrikConnection['clusterName']}/api/v2/sla_domain/#{id.to_s}"
            
            uri = URI.parse(uristring)
            $logger.debug("URI used: " + uri.to_s)

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            
            header = {}
            header['Authorization'] = "Bearer #{$rubrikConnection['token']}"

            result = http.delete(uri.request_uri, header)
            $logger.debug("HTTP status code: " + result.code)
            
            puts result.response.body
        else
            $logger.error("Not authenticated, the #{__method__.to_s} method requires you to authenticate to the Rubrik cluster first")
        end
    end
end

class ClusterConnection
    def self.connectBasicAuth(clusterName:, logging: 'WARN', userName:, password:)
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")

        if (logging.to_s) == "debug"
            $logger.level = Logger::DEBUG
        else
            $logger.level = Logger::WARN
        end

        uristring = "https://" + clusterName + "/api/v1/session"
        
        uri = URI.parse(uristring)
        $logger.debug("URI used: " + uri.to_s)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        header = {}
        header['Authorization'] = 'Basic ' + Base64.encode64("#{userName.to_s}:#{password.to_s}").chop
        header['User-Agent'] = self.userAgentString().to_s
        $logger.debug("User-Agent string: #{header['User-Agent']}")

        result = http.post(uri.request_uri,'',header)
        $logger.debug("HTTP status code: " + result.code)
        
        $rubrikConnection = {}
        $rubrikConnection['token'] = (JSON.parse(result.response.body))['token']
        $rubrikConnection['clusterName'] = clusterName.to_s
    end

    def self.connectToken(clusterName:, logging: 'WARN', apiToken:)
        $logger.debug("Executing method '#{__method__.to_s}', method of '#{self.name.to_s}' class")

        if (logging.to_s) == "debug"
            $logger.level = Logger::DEBUG
        else
            $logger.level = Logger::WARN
        end

        $rubrikConnection = {}
        $rubrikConnection['token'] = apiToken.to_s
        $rubrikConnection['clusterName'] = clusterName.to_s
    end

    def self.connected?
        if defined?($rubrikConnection)
            true
        else
            false
        end
    end

    def self.userAgentString()
        "RubrikRubySDK-0.0.1"
    end
end