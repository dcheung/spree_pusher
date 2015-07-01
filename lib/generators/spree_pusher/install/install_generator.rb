module SpreePusher
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)

      def add_initializer
        copy_file "pusher.rb", "config/initializers/pusher.rb"
      end

    end
  end
end
