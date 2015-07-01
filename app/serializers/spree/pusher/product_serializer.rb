require 'active_model/serializer'

module Spree
  module Pusher
    class ProductSerializer < ActiveModel::Serializer

      attributes :id, :name, :sku, :description, :price, :cost_price,
                 :available_on, :permalink, :meta_description, :meta_keywords,
                 :shipping_category, :taxons, :options, :weight, :height, :width,
                 :depth, :variants

      has_many :images, serializer: Spree::Pusher::ImageSerializer

      def id
        object.sku
      end

      def price
        object.price.to_f
      end

      def cost_price
        object.cost_price.to_f
      end

      def available_on
        object.available_on.try(:iso8601)
      end

      def permalink
        object.slug
      end

      def shipping_category
        object.shipping_category.name
      end

      def taxons
        object.taxons.collect {|t| t.self_and_ancestors.collect(&:name)}
      end

      def options
        object.option_types.pluck(:name)
      end

      def variants
        if object.variants.empty?
          [Spree::Pusher::VariantSerializer.new(object.master, root:false)]
        else
          ActiveModel::ArraySerializer.new(
            object.variants,
            each_serializer: Spree::Pusher::VariantSerializer,
            root: false
          )
        end
      end
    end
  end
end
