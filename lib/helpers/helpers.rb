module Grouper
  
  def rails?
    defined?(Rails) || defined?(RAILS_ROOT)
  end
  
  module Helper
    
    def auto_include(options={})
      @layout ||= options[:layout]
      if Grouper.rails?
        @layout_directory = File.join(RAILS_ROOT,"app","views","layouts")
        @layout_filename  = Dir.glob(File.join(@layout_directory, "#{@layout}.?"))[0]
        javascript_include_tag Grouper.assets_for(:layout => @layout, :filename => @layout_filename)
      end
    end
  
  end
  
end