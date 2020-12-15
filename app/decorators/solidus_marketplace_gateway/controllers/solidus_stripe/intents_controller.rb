# frozen_string_literal: true

module SolidusMarketplaceGateway
  module Controller
    module SolidusStripe
      module IntentsController
        def intent_options
          options = {
            description: "Solidus Order ID: #{current_order.number} (pending)",
            currency: current_order.currency,
            confirmation_method: 'automatic',
            capture_method: 'manual',
            confirm: true,
            setup_future_usage: 'off_session',
            metadata: { order_id: current_order.id },
            application_fee: SolidusMarketplace::Config[:default_commission_flat_rate]
          }
          add_extra_options(options)
          options
        end

        def add_extra_options(options)
          return unless connected_account

          case @stripe.preferred_connected_mode
            when 'direct_charge'
              options.merge!(stripe_account: connected_account)
            when 'destination_charge'
              options.merge!(transfer_destination: connected_account)
          end
        end

        def create_payment_intent
          stripe.create_intent(
            (current_order.total * 100).to_i,
            params[:stripe_payment_method_id],
            intent_options
          )
        end

        private

        def connected_account
          # TODO: handle order with multiple suppliers
          supplier = current_order.suppliers.first
          supplier_payment_method = Spree::SupplierPaymentMethod.find_by(
            supplier: supplier,
            payment_method: @stripe
          )
          supplier_payment_method.connected_account
        end
      end
    end
  end
end

SolidusStripe::IntentsController.prepend SolidusMarketplaceGateway::Controller::SolidusStripe::IntentsController
