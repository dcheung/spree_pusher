require 'active_model/serializer'

module Spree
  module Pusher
    class RefundSerializer < ActiveModel::Serializer
      attributes :reason, :amount, :description
      has_one :payment, serializer: Spree::Pusher::PaymentSerializer

      def reason
        object.reason.try(:name)
      end
    end
  end
end
