# frozen_string_literal: true

module Spree
  class SupplierPaymentMethod < Spree::Base
    belongs_to :supplier
    belongs_to :payment_method
  end
end
