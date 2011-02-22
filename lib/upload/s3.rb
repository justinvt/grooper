require "s3"

module Grooper
  module Upload
  
    module AWSS3
    
      @@bucket = ENV["EC2_BUCKET"]
    
      def self.service(options={})
        S3::Service.new(:access_key_id => options[:access_key] || ENV["EC2_ACCESS_KEY"],
                                  :secret_access_key => options[:secret_key] || ENV["EC2_SECRET"])
      end
                                        
      def self.upload(options={})
        bucket = service(options).buckets.find( options[:bucket] || @@bucket )
        filename = options[:file]
        asset = bucket.objects.build(File.basename(filename))
        asset.content_type = "text/javascript"
        asset.content = open(filename)
        asset.save
        asset
      end

    end
  
  end

end
