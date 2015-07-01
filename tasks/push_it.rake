require 'spree/pusher'

namespace :pusher do
  desc 'Push batches via Pusher'
  task :push_it => :environment do

    credentials = Spree::Pusher::Config[:credentials]
    if credentials != nil && (credentials[:connection_token] == "YOUR TOKEN" || credentials[:connection_id] == "YOUR CONNECTION ID")
      abort("[ERROR] It looks like you did not add your credentails to config/intializers/pusher.rb, please add them and try again. Exiting now")
    end
    puts "\n\n"
    puts "Starting pushing objects via Pusher"
    Spree::Pusher::Config[:push_objects].each do |object|
      clientString = Spree::Pusher::Config[:payload_builder][object][:pusher_client] || Spree::Config[:pusher_client]
      client = clientString.constantize
      objects_pushed_count = client.push_batches(object)
      puts "Pushed #{objects_pushed_count} #{object} via Pusher"
    end
  end
end
