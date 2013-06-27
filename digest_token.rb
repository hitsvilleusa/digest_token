# Usage inside of ActiveRecord Model:
#   digest_token :confirmation
#
# Gives the following method:
#   create_confirmation_token
#   on before_create it will call this method

require 'digest/sha1'

module ActiveRecord
  module DigestToken
    extend ActiveSupport::Concern
    
    module ClassMethods
      def digest_token(token_name)
        create_token_method(token_name)
        
        before_create "create_#{token_name}_token"
      end
      
      def create_token_method(token_name)
        define_method("create_#{token_name}_token") do
          rand_message      = "#{Time.now}-#{(1..10).map{rand(36).to_s(36)}.join}"
          self.send("#{token_name}_token=", Digest::SHA1.hexdigest(rand_message))
        end
      end
    end
  end
end


module ActiveRecord
  class Base
    include DigestToken
  end
end