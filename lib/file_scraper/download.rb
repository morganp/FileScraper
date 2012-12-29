

module FileScraper

  class Download

    def self.run(data, download_path )
      
      data.each do |item|
        name          = item.title
        download_name = File.join( download_path, name)

        if not File.exist?( download_name )  
          puts "--> #{name}"
          begin
            try_download(download_name, item)
          rescue OpenSSL::SSL::SSLError
            set_ssl_cert
            try_download(download_name, item)
          end

        else 
          puts "Got #{name}"
        end
      end
    end

    def self.try_download( download_name, item )
      open( download_name, 'wb') do |file|
        file << open( item.link ).read
      end
    end

    def self.set_ssl_cert
      found_possible_cert = false

      potential_ssl_cert_locations = []
      # Previous Run of this program
      potential_ssl_cert_locations <<  "cacert.pem"
      
      # RHEL & Cent OS
      potential_ssl_cert_locations << "/etc/pki/tls/certs/ca-bundle.crt" 

      # Ubuntu
      potential_ssl_cert_locations << "/etc/ssl/certs/ca-certificates.crt"
      
      potential_ssl_cert_locations <<  "/usr/local/rvm/usr/ssl/certs/cacerts"
      potential_ssl_cert_locations.each do |loc|
        if File.exist?( loc )
          found_possible_cert  = true
          ENV['SSL_CERT_FILE'] = loc
          break
        end
      end

      potential_ssl_cert_folder = []
      potential_ssl_cert_folder << "/usr/share/ca-certificates/"
      potential_ssl_cert_folder << "/usr/share/curl/"
      potential_ssl_cert_folder << "~/.rvm/usr/ssl/"
      
      potential_ssl_cert_folder.each do |loc|
        if File.exist?( loc )
          ENV['SSL_CERT_DIR'] = loc
          found_possible_cert  = true
          break
        end
      end

      unless found_possible_cert
        download_cert
      end

    end

    def self.download_cert
      $stderr.puts "OpenSSL::SSL::SSLError Occured on potential SSL Cert certificates found"
      $stderr.puts "  Downloading SSL Certs from http:///curl.haxx.se"
      open( "cacert.pem", 'wb') do |file|
        file << open( "http://curl.haxx.se/ca/cacert.pem" ).read
      end
      ENV['SSL_CERT_FILE'] = "cacert.pem"
    end

  end
end

