# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Intent Request", type: :request do
  let(:order) { create(:order_from_supplier) }
  let(:payment_method) { create(:stripe_credit_card) }
  let!(:supplier_payment_method) {
    Spree::SupplierPaymentMethod.create(
      supplier: order.suppliers.first,
      payment_method: payment_method,
      connected_account: "acct_17FRNfIPBJTitsen"
    )
  }
  let(:connected_account) { supplier_payment_method.connected_account }

  before do
    SolidusMarketplace::Config[:default_commission_flat_rate] = 10.0
    ActionController::Base.allow_forgery_protection = false
    allow_any_instance_of(ActiveMerchant::Billing::StripePaymentIntentsGateway)
      .to receive(:create_intent).and_return(true)
    allow_any_instance_of(SolidusStripe::IntentsController)
      .to receive(:generate_payment_response)
      .and_return(JSON.generate({ success: true }))
    allow_any_instance_of(SolidusStripe::IntentsController)
      .to receive(:current_order).and_return(order)
  end

  after do
    ActionController::Base.allow_forgery_protection = true
  end

  it "send application_fee option" do
    expect_any_instance_of(ActiveMerchant::Billing::StripePaymentIntentsGateway)
      .to receive(:create_intent)
      .with(any_args, nil, hash_including(application_fee: BigDecimal(10)))

    post "/stripe/create_intent", params: {
      spree_payment_method_id: payment_method.id,
      stripe_payment_method: '1222w'
    }
  end

  it "send stripe_account option" do
    expect_any_instance_of(ActiveMerchant::Billing::StripePaymentIntentsGateway)
      .to receive(:create_intent)
      .with(any_args, nil, hash_including(stripe_account: connected_account))

    post "/stripe/create_intent", params: {
      spree_payment_method_id: payment_method.id,
      stripe_payment_method: '1222w'
    }
  end

  context "with destination_charge mode" do
    let(:payment_method) {
      create(:stripe_credit_card, preferred_connected_mode: "destination_charge")
    }

    it "send transfer_destionation option" do
      expect_any_instance_of(ActiveMerchant::Billing::StripePaymentIntentsGateway)
        .to receive(:create_intent)
        .with(any_args, nil, hash_including(transfer_destination: connected_account))

      post "/stripe/create_intent", params: {
        spree_payment_method_id: payment_method.id,
        stripe_payment_method: '1222w'
      }
    end
  end
end
