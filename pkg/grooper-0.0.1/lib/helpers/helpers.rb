module Grooper
  
  def rails?
    defined?(Rails) || defined?(RAILS_ROOT)
  end
  
  module Helper
    
    def auto_include(options={})
      @layout ||= options[:layout]
      if Grooper.rails?
        @layout_directory = File.join(RAILS_ROOT,"app","views","layouts")
        @layout_filename  = Dir.glob(File.join(@layout_directory, "#{@layout}.?"))[0]
        javascript_include_tag Grooper.assets_for(:layout => @layout, :filename => @layout_filename)
      end
    end
  
  end
  
end