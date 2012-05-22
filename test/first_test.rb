$:.unshift File.expand_path('..', __FILE__)
require 'test_helper'

describe 'FirstSpec' do
  it "should just work" do
    true.must_equal true
  end

  it "should really just work" do
    false.must_equal false
  end
end
