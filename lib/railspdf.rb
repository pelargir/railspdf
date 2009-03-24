require 'pdf/writer'
require 'pdf/simpletable'

module RailsPDF
  
 	#this code comes from http://wiki.rubyonrails.com/rails/pages/HowtoGeneratePDFs 	
	class PDFRender < ActionView::Base
  	include ApplicationHelper

    def initialize(action_view)
      @action_view = action_view
      helper_name = "#{action_view.controller.controller_name.classify}Helper"
      action_view.class.send(:include, helper_name.constantize) if Object.const_defined?(helper_name)
  	end

  	def self.compilable?
      false
    end

    def compilable?
      self.class.compilable?
    end

    def render(template, local_assigns = {})
    	
    	#get the instance variables setup	    	
   		@action_view.controller.instance_variables.each do |v|
        instance_variable_set(v, @action_view.controller.instance_variable_get(v))
      end
		
			#keep ie happy
			if @action_view.controller.request.env['HTTP_USER_AGENT'] =~ /msie/i
        @action_view.controller.headers['Pragma'] ||= ''
        @action_view.controller.headers['Cache-Control'] ||= ''
   		else
        @action_view.controller.headers['Pragma'] ||= 'no-cache'
        @action_view.controller.headers['Cache-Control'] ||= 'no-cache, must-revalidate'
   		end
   		
   		@action_view.controller.headers['Content-Type'] = 'application/pdf'
			if @rails_pdf_name
				@action_view.controller.headers['Content-Disposition'] = 'attachment; filename="' + @rails_pdf_name + '"'
			elsif @rails_pdf_inline
				#set no headers
			else #rails_pdf_inline was set to false.  set filename = controller name
				 #since we weren't provided a custom name
				@action_view.controller.headers['Content-Disposition'] = 'attachment; filename="' + @action_view.controller.controller_name + '.pdf' + '"'
			end
      
      if @landscape
     		pdf = PDF::Writer.new( :paper => (@paper || 'A4'), :orientation => :landscape )
      else
     		pdf = PDF::Writer.new( :paper => (@paper || 'A4') )
      end
 	  	pdf.compressed = true if RAILS_ENV != 'development'
 	  	
	    eval template.source, nil
   		pdf.render
  	end
  	
  	def self.call(template)
      "RailsPDF::PDFRender.new(self).render(template, local_assigns)"
    end
  end
end
