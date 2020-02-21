module Shipit
  class AnonymousUserSerializer < UserSerializer
    def anonymous
      true
    end
  end
end
