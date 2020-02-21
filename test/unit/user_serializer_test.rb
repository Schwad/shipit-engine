require 'test_helper'

module Shipit
  class UserSerializerTest < ActiveSupport::TestCase
    test 'includes anonymous key' do
      serialized = UserSerializer.new(User.new).to_json
      assert_equal false, JSON.parse(serialized)["anonymous"]
    end
  end
end
