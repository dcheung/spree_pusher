require 'json'
require 'openssl'
require 'httparty'
require 'active_model/array_serializer'

module Spree
  module Pusher
    class Client
      def self.push_batches(object, ts_offset = 5)
        object_count = 0

        last_push_time = Spree::Pusher::Config[:last_pushed_timestamps][object] || Time.at(0)
        this_push_time = Time.now

        payload_builder = Spree::Pusher::Config[:payload_builder][object]

        model_name = payload_builder[:model].present? ? payload_builder[:model] : object

        scope = model_name.constantize

        if filter = payload_builder[:filter]
          scope = scope.send(filter.to_sym)
        end

        scope = yield(scope) if block_given?

        # go 'ts_offset' seconds back in time to catch missing objects
        last_push_time = last_push_time - ts_offset.seconds

        scope.where(updated_at: last_push_time...this_push_time).find_in_batches(batch_size: Spree::Pusher::Config[:batch_size]) do |batch|
          object_count += batch.size
          payload = format_batch(batch, payload_builder)
          
          push_url = payload_builder[:push_url] || Spree::Pusher::Config[:push_url]
          http_request = get_http_request(payload, payload_builder[:credentials])

          push(push_url, http_request)
        end

        update_last_pushed(object, this_push_time)
        object_count
      end

      def self.push(push_url, http_request)
        res = HTTParty.post(push_url,http_request)

        validate(res)
      end
      
      private
      def self.format_batch(batch, payload_builder)
        raise "NotImplementedException"
      end
      
      def self.get_http_request(json_payload, credentials)
        raise "NotImplementedException"
      end

      def self.update_last_pushed(object, new_last_pushed)
        last_pushed_ts = Spree::Pusher::Config[:last_pushed_timestamps]
        last_pushed_ts[object] = new_last_pushed
        Spree::Pusher::Config[:last_pushed_timestamps] = last_pushed_ts
      end

      def self.validate(res)
        raise PushApiError, "Push not successful. Pusher returned response code #{res.code} and message: #{res.body}" if res.code != 202
      end
    end
  end
end

class PushApiError < StandardError; end
