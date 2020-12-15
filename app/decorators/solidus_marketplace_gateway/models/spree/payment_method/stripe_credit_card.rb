# frozen_string_literal: true

module SolidusMarketplaceGateway
  module Models
    module Spree
      module PaymentMethod
        module StripeCreditCard
          extend ActiveSupport::Concern

          included do
            preference :connected_mode, :string, default: 'direct_charge'
          end
        end
      end
    end
  end
end

Spree::PaymentMethod::StripeCreditCard.include SolidusMarketplaceGateway::Models::Spree::PaymentMethod::StripeCreditCard
