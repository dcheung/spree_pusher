require 'spree/pusher/client'

module Spree
  module Pusher
    class WombatClient < Client

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
           'X-Hub-Store'        => credentials[:connection_id],
           'X-Hub-Access-Token' => credentials[:connection_token],
           'X-Hub-Timestamp'    => Time.now.utc.to_i.to_s
          }
        }
      end
    end
  end
end
