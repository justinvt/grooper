module Grouper
  class Asset
  
    @@defaults = {}
    attr_accessor :path_type, :init_options, :settings, :path, :basename, :filetype, :directory, :path_components, :sort_order
  
  
    def initialize(options={})
      @init_options = options
      populate_settings
    end
  
    def populate_settings
      @init_options[:remote] ||= (@init_options[:url] && !@init_options[:file])
      @path              = @init_options.values_at(:url, :file).compact[0]
      @settings          = OpenStruct.new( @init_options )
    end
  
    def remote?; settings.remote; end
  
    def local?; !remote?; end
  
    def path_type
      @path_type || ( remote? ? :url : :file )
    end
  
    def path_parser
      [:set_from, path_type].map(&:to_s).join("_")
    end
  
    def path_components
      @path_components || send(path_parser)
    end
  
    def lib_object
    #  puts @path
      remote? ? URI.parse(@path) : Pathname.new(@path)
    end
  
    def relative_path
      remote? ? lib_object.path : @path
    end
  
    def pathname_object
      Pathname.new(relative_path)
    end
  
    def directory
      pathname_object.dirname
    end
  
    def exists?
    end
  
    def filename
      pathname_object.basename
    end
  
    def ext
      pathname_object.basename.to_s.scan(/\.\w+$/)[0]
    end
  
    def contents
      open(path).read
    end
  
    def for_set
      remote? ? {:url => path} : {:file => path}
    end
  
  end

end