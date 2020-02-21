require 'test_helper'

module Shipit
  class AnonymousUserSerializerTest < ActiveSupport::TestCase
    test 'includes anonymous key' do
      serialized = AnonymousUserSerializer.new(AnonymousUser.new).to_json
      assert_equal true, JSON.parse(serialized)["anonymous"]
    end
  end
end
