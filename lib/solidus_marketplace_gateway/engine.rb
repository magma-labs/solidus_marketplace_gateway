# frozen_string_literal: true

require 'spree/core'
require 'solidus_marketplace_gateway'

module SolidusMarketplaceGateway
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_marketplace_gateway'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
