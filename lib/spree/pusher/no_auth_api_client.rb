require 'spree/pusher/client'

module Spree
  module Pusher
    class NoAuthApiClient < Client
      private
      def self.format_batch(batch, payload_builder)
        return ActiveModel::ArraySerializer.new(
          batch,
          each_serializer: payload_builder[:serializer].constantize,
          root: payload_builder[:root]
        ).to_json
      end

      def self.get_http_request(json_payload, credentials)
        return {
          body: json_payload,
          headers: {
           'Content-Type'       => 'application/json',
          }
        }
      end
    end
  end
end
