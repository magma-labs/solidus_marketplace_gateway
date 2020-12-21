# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_credit_card, class: 'Spree::PaymentMethod::StripeCreditCard' do
    name { 'Stripe' }
    preferred_secret_key { 'sk_test_VCZnDv3GLU15TRvn8i2EsaAN' }
    preferred_publishable_key { 'pk_test_Cuf0PNtiAkkMpTVC2gwYDMIg' }
    preferred_v3_elements { false }
    preferred_v3_intents { true }
  end
end
