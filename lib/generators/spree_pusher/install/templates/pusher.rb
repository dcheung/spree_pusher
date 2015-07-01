Spree::Pusher::Config.configure do |config|

  config.credentials = {
    :connection_token => "YOUR TOKEN",
    :connection_id => "YOUR CONNECTION ID"
  }

  # config.push_objects = ["Spree::Order", "Spree::Product"]
  # config.payload_builder = {
  #   # By default we filter orders to only push if they are completed.  You can remove the filter to send incomplete orders as well.
  #   "Spree::Order" => { serializer: "Spree::Pusher::OrderSerializer", root: "orders", filter: "complete" },
  #   "Spree::Product" => { serializer: "Spree::Pusher::ProductSerializer", root: "products" },
  #   "Spree::StockItem" => { serializer: "Spree::Pusher::StockItemSerializer", root: "inventories" }
  # }
  #config.push_url = "https://push.wombat.co"

end
