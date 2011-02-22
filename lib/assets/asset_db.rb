module Grouper
  class AssetDB
  
    @@db_yaml_filename = 'assets.yml'
  
    attr_accessor :db_filename, :yaml_db, :asset_sets, :loaded_sets
  
    def initialize(options={})
      @db_filename = options[:file] || @@db_yaml_filename
      @yaml_db     = YAML::load( open(@db_filename).read )
      @asset_sets  = {}
      @loaded_sets = []
      @yaml_db.each_pair do |k,v|
        Grouper.log.debug "Parsing yaml block \"#{k}\""
        append_set k.to_sym, :files => gather_files(k)
      end
      @set_list = @yaml_db.clone
    end
  
    def asset_block(asset_hash)
      obj = OpenStruct.new(asset_hash)
    end
  
    def parse_template(options)
      if options[:filename]
        document = Nokogiri::HTML(open(options[:filename])) 
      elsif options[:html]
        document = Nokogiri::HTML( options[:html] ) 
      else
        document = nil
      end
      document
    end
  
    def block_matches(asset_hash, options={})
      block_name = options[:block_name]
      set        = asset_block(asset_hash)
      document   = parse_template(options)
      layouts    = (set.context && set.context[:layouts])   ? set.context[:layouts]   : nil
      selectors  = (set.context && set.context[:selectors]) ? set.context[:selectors] : nil
      layout_match   = options.keys.include?(:layout) && layouts && layouts.include?( options[:layout] )
      selector_match = document && selectors && !selectors.reject{|selector| document.css(selector).empty? }.empty?
      Grouper.log.info "Asset Block \"#{block_name}\" matches layout \"#{options[:layout]}\"....including in our assets" if layout_match 
      Grouper.log.info "Asset Block  \"#{block_name}\" matches one or more selectors \"#{selectors.inspect}\ in file \"#{options[:filename]}\"....including in our assets" if selector_match
      layout_match || selector_match
    end
  
    def matching_sets(options={})
      Grouper.log.info "\nasset_db.matching_sets: Finding all blocks in #{@db_filename} that should be loaded for #{[:layout, :filename, :html].reject{|k| options[k].nil?}.map{|k| k.to_s + ' "' + options[k] + '"'}.join(' and ')}\n\n"
      matches = @set_list.select{|k,v| options.merge!(:block_name => k); block_matches(v, options) }.map{|s| s[0]}
      block_given? ? matches.map{|m| yield(m) } : matches
    end
  
    def gather_files(set_name)
      values = @yaml_db[set_name.to_sym] || @yaml_db[set_name]
      files  = values.nil? ? [] : values[:files].to_a
      sets   = values.nil? ? [] : ( values[:sets].to_a  )
      Grouper.log.debug "#{set_name} consists of #{files.empty? ? "no files" : "files " + files.inspect} and of #{sets.empty? ? "no file sets" : "file sets " + sets.inspect}"
      @loaded_sets = [ @loaded_sets, sets].flatten.uniq
      to_load = [ files, sets.map{|s| gather_files(s) } ].flatten.to_a.uniq
      return to_load
    end

    def matching_scripts(options={})
       matching_sets(options){|m|  @asset_sets[m.to_sym].files }.flatten.uniq
    end
  
    def group(name)
      @asset_sets[name.to_sym]
    end
  
    def append_set(name, options={})
      Grouper.log.debug "Creating Asset set \"#{name}\" - which contains files #{options[:files].inspect}\n\n"
      @asset_sets[name.to_sym] = AssetSet.new(name.to_s, options)
    end
  
    def superset(name, options={})
      files = options[:from].map{|s| @asset_sets[s.to_sym].files }.flatten
      return append_set(name, :files => files,  :from => options[:from])
    end
  
    def content
      output = {}
      @asset_sets.each_pair do |k,v|
        output[k] = v.to_tiny_yaml
      end
      YAML::dump( output  )
    end
  
    def save
      f = File.open(db_filename, "w+")
      f.puts content
      f.close
    end
  
  end
end