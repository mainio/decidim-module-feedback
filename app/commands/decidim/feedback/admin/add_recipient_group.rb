# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # A command to add a new recipient group.
      class AddRecipientGroup < Decidim::Command
        # Public: Initializes the command.
        #
        # form - The recipint group form.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the handler wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          create_group!

          broadcast(:ok, group)
        end

        private

        attr_reader :group, :form

        def create_group!
          @group = Decidim::Feedback::RecipientGroup.create!(
            organization: form.current_organization,
            name: form.name,
            recipient_emails: form.recipient_emails,
            metadata_conditions: form.metadata_conditions
          )
        end
      end
    end
  end
end
