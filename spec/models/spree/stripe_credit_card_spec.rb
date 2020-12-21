# frozen_string_literal: true

require 'spec_helper'

describe Spree::PaymentMethod::StripeCreditCard, type: :model do
  it { is_expected.to respond_to(:preferred_connected_mode) }
end
