require File.dirname(__FILE__) + '/test_helper'

class SomeController < ActionController::Base; end
module SomeHelper; end

class AnotherController < ActionController::Base; end

class RailsPDF::PDFRenderTest < Test::Unit::TestCase
  
  def test_should_not_barf_on_missing_helper
    view = stub(:controller => AnotherController.new)
    RailsPDF::PDFRender.new(view)
  end
end
