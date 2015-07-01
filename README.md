# Spree Pusher

Connect your SpreeCommerce Storefront to an API endpoint

## Installation

Add spree_pusher to your Gemfile:

```ruby
gem 'spree_pusher', github: 'MisinformedDNA/spree_pusher', branch: 'master'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_pusher:install
```

## Configuration

All the configuration is done inside the initializer here: `config/initializers/pusher.rb` all the default settings can be found there as well. Below we will explain all of them

### credentials

Sets the credentials for the API calls.

To set the credentials for all the requests
```ruby

# Wombat
Spree::Pusher::Config.configure do |config|
  config.credentials = {
    :connection_token => "YOUR TOKEN"
    :connection_id => "YOUR CONNECTION ID"
  }
end

# Azure Logic Apps

Spree::Pusher::Config.configure do |config|
  config.credentials = { 
    :access_key, "ACCESS_KEY"
  }
end
```

To set the credentials for a specific object

```ruby
config.payload_builder = {
  "Spree::Order"  => {
    :serializer => "Spree::Pusher::OrderSerializer", 
    :credentials = {
      :access_key => "ACCESS_KEY"
    }
  }
}
```

### pusher_client

By default, all objects are pushed to Wombat. To push them elsewhere, such as Azure Logic Apps, you can set pusher_client

config.pusher_client = "Spree::Pusher::AzureLogicAppClient"

You can also specify `:pusher_client` in the payload_builder

The difference between `pusher_client` and `push_url` is that a `pusher_client` can perform API specific tasks like additional formatting or customize the HTTP request, where as `push_url` is simply the URL the request is made against. 

### push_objects

The push_objects is an array of model names that are selected to push to the API endpoints. We use these as keys in other places as well to configure how the payload is serialized and to keep track of the last time we pushed the objects.

```ruby
config.push_objects = ["Spree::Order", "Spree::Product"]
```

By default we only push `Spree::Order` and `Spree::Product` models.

### payload_builder

To push the data, we need to configure the way on how to construct the JSON payload.


```ruby
config.payload_builder = {
  "Spree::Order"  => {:serializer => "Spree::Pusher::OrderSerializer", :root => "orders"},
  "Spree::Product" => {:serializer => "Spree::Pusher::ProductSerializer", :root => "products"},
}
```

The payload builder is a hash, the key is the model name we also use in the `push_objects` config.

Each model has a `serializer` and a `root` field that defines the serializer we use to serialize to JSON and the root defines the root node for that JSON.

We have defined serializers for the default objects, you can find them [here](https://github.com/MisinformedDNA/spree_pusher/tree/master/app/serializers/spree/pusher)

To push other objects to an API endpoint, you only need to add an entry in the `push_objects` and the `payload_builder` configurations.


### last_pushed_timestamps

For every model we push to an API endpoint, we keep track of when we pushed the objects.

Do not add this in `config/initializers/pusher.rb` otherwise it will reset the data on each restart.

Instead, if you need to reset data or want to update a timestamp for an object you can do so in the console

```shell
timestamps = Spree::Pusher::Config[:last_pushed_timestamps]
timestamps["Spree::Order"] = 2.days.ago
Spree::Pusher::Config[:last_pushed_timestamps] = timestamps
```

This will update the preference in the database and will use your updated timestamp for, in this case, 'Spree::Order'

## Push to API endpoints

To push objects to API endpoints we provide you with the following rake task:

```shell
bundle exec rake pusher:push_it
```

This task will collect all the objects from `push_objects` that are not yet pushed (defined in `last_pushed_timestamps`) and will push those objects in batches of 10 to the specified API endpoint.

You could also add a background task to make that happen, all you need there are these lines:

```ruby
Spree::Pusher::Config[:push_objects].each do |object|
  Spree::Pusher::Client.push_batches(object)
end
```

If you want to push Spree::Orders manually for example, you can call this:

```ruby
Spree::Pusher::Client.push_batches("Spree::Order")
```

### push_url

The default is https://push.wombat.co. You can override the default url to push your data to.

```ruby
config.push_url = "http://mycustomurl"
```

You can also specify `:push_url` in the payload_builder


## Create custom serializers

```shell
bundle exec rails g spree_pusher:serializer Spree::Order MyOrderSerializer
```

This will generate a serializer for the provided model name, when the model is already configured in the `payload_builder` we use that serializer name as super class to inherit from. With active_model_serializer you also inherit the attributes so you can keep the existing configuration and only change that what's needed.

The generator will also automatically set the correct configuration in `config/initializers/pusher.rb`

## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

Copyright (c) 2014 Spree Commerce, Inc. and other contributors, released under the New BSD License
