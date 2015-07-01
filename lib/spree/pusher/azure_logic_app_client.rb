require 'spree/pusher/client'

module Spree
  module Pusher
    class AzureLogicAppClient < Client
      private
      def self.format_batch(batch, payload_builder)
        payload = ActiveModel::ArraySerializer.new(
          batch,
          each_serializer: payload_builder[:serializer].constantize,
          root: payload_builder[:root]
        )
        return { "outputs": payload }.to_json
      end

      def self.get_http_request(json_payload, credentials)
        return {
          body: json_payload,
          basic_auth: {
            :username => "default", 
            :password => credentials[:access_key]
		      },
          headers: {
           'Content-Type' => 'application/json'
          }
        }
      end
    end
  end
end
