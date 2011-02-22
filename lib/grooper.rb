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

LOG_LEVEL = Logger::DEBUG

module Grooper
  
  @@log = Logger.new(STDOUT)
  @@log.level = LOG_LEVEL
  @@log.datetime_format = "%Y-%m-%d %H:%M:%S "
  
  @@default_assets_yaml = "assets.yaml"
  @@default_config_yaml = "assets.yaml"
  
  class << self
    
    def log
      @@log
    end
    
    def log_level=(logger_level)
      log.level = logger_level
    end
  
    def assets_for(options={})
      AssetDB.new.matching_scripts(options)
    end
  
  end
  
end

require_all "./lib/exceptions"
require_all "./lib/assets"
require_all "./lib/upload"
require_all "./lib/helpers"