module RSpec
  module Rails
    # Raises an error if the user tries to call integration test helpers.
    # If the helpers are available then this module will be ignored.
    module IntegrationHelperWarnings
      extend ActiveSupport::Concern
      [:assert_select, :url_for, :url_options].each do |name|
        define_method(name) { |*| raise "you must upgrade Rails to call #{name}" }
      end
    end

    # @api public
    # Container class for request spec functionality.
    module RequestExampleGroup
      extend ActiveSupport::Concern
      include RSpec::Rails::RailsExampleGroup
      include ActionDispatch::Integration::Runner
      include ActionDispatch::Assertions
      include RSpec::Rails::Matchers::RedirectTo
      include RSpec::Rails::Matchers::RenderTemplate
      include ActionController::TemplateAssertions

      begin
        include ActionDispatch::IntegrationTest::Behavior
      rescue NameError
        include IntegrationHelperWarnings
      end

      # Delegates to `Rails.application`.
      def app
        ::Rails.application
      end

      included do
        before do
          @routes = ::Rails.application.routes
        end
      end
    end
  end
end
