require 'active_model/serializer'

module Spree
  module Pusher
    class PaymentSerializer < ActiveModel::Serializer
      attributes :id, :number, :status, :amount, :payment_method

      has_one :source, serializer: Spree::Pusher::SourceSerializer

      def number
        object.identifier
      end

      def payment_method
        object.payment_method.name
      end

      def status
        object.state
      end

      def amount
        object.amount.to_f
      end
    end
  end
end
