require 'rubygems'
require 'sinatra'
require 'json'
require "yaml"
require 'digest/md5'
require 'json'
require 'net/http'
require 'uri'
require 'open-uri'
require 'pathname'
require 'ostruct'
require 'nokogiri'
require 'require_all'
require 'logger'
require "s3"


module Grooper
  
  
  GROOPER_ROOT = File.expand_path( File.join( File.dirname(__FILE__), ".."))
  
  @@log = Logger.new(STDOUT)
  @@log.level = Logger::DEBUG
  @@log.datetime_format = "%Y-%m-%d %H:%M:%S "
  @@record = {}
  
  class << self
    
    def rails?
      defined?(Rails) || defined?(RAILS_ROOT)
    end
    
    def config_root
      rails? ? File.join(RAILS_ROOT, "config") : GROOPER_ROOT
    end
    
    def assets_config_file
      path = File.join(config_root, "assets.yml")
      puts path
      path
    end
    
    def grooper_config_file
      path = File.join(config_root, "config.yml")
      puts path
      path
    end
    
    def asset_record_file
      path = File.join(config_root, "record.yml")
      puts path
      path
    end
    
    def require_lib(*paths)
      path = File.join([ GROOPER_ROOT, "lib", paths.to_a.map{|p| p.to_s} ].flatten)
      puts path
      require_all path
    end
    
    def log
      @@log
    end
    
    def log_level=(logger_level)
      log.level = logger_level
    end
  
    def assets_for(options={})
      AssetDB.new.matching_scripts(options)
    end
    
    def record_asset(options={})
      @@record[options[:controller]] ||= {}
      @@record[options[:controller]][options[:action]] ||= []
      @@record[options[:controller]][options[:action]] = @@record[options[:controller]][options[:action]] + options[:files]
      @@record[options[:controller]][options[:action]] = @@record[options[:controller]][options[:action]].uniq
      record_assets
    end
    
    def record_assets
      yaml_text = YAML::dump( @@record )
      f = File.open(asset_record_file, "w+")
      f.puts yaml_text
      f.close
    end
    
    # Work in progress
    def blah_record_assets
      if rails?
        controller_directory = File.join(RAILS_ROOT,"app","controllers")
        controllers = Dir.entries(controller_directory).map{|f| File.basename(f).gsub(/\.[\w]+$/,'').classify }
        puts "Controllers = #{controllers.inspect}"
        models      = controllers.map{|c| c.gsub(/sController$/,'')}
        user        = Account.first
        controllers.each_with_index do |c,i|
          next if (c.length < 2 || c =~ /^Application/ )
          [:new, :show, :edit, :index ].each do |action|
          #  begin
              puts "Running #{c}/#{action}"
              instance = c.constantize.new
              instance.instance_variable_set('@current_user',user)
              instance_model = models[i].constantize.first
              action_string = [models[i].tableize.gsub(/s$/,''), action].map{|s| s.to_s}.join("/")
              instance.params={:id => instance_model.id, :format => "html"}
              instance.send(action)
              html = instance.render_to_string(:action => action_string, :layout => instance.active_layout)
              doc = Nokogiri::HTML(instance.instance_variable_get("@template_html"))
              doc.xpath('//script').each do |script|
                puts script["src"]
              end
          #  rescue => e
          #    puts e.message
          #    next
          #  end
          end
        end
      else
        raise 'you must be running grouper in a rails app to use this method'
      end
    end
  
  end
  
end

Grooper.require_lib(:exceptions)
Grooper.require_lib(:upload)
Grooper.require_lib(:assets)
Grooper.require_lib(:helpers)
