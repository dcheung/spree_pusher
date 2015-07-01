module Spree
  class PusherConfiguration < Preferences::Configuration
    preference :batch_size, :integer, default: 10
    preference :pusher_client, :string, :default => "Spree::Pusher::WombatClient"
    preference :credentials, :hash
    preference :push_url, :string, :default => 'https://push.wombat.co'
    preference :push_objects, :array, :default => ["Spree::Order", "Spree::Product"]
    preference :payload_builder, :hash, :default => {
      "Spree::Order" => {:serializer => "Spree::Pusher::OrderSerializer", :root => "orders", :filter => "complete"},
      "Spree::Product" => {:serializer => "Spree::Pusher::ProductSerializer", :root => "products"},
    }
    preference :last_pushed_timestamps, :hash, :default => {
      "Spree::Order" => nil,
      "Spree::Product" => nil
    }
  end
end
