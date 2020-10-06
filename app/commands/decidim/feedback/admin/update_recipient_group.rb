# frozen_string_literal: true

module Decidim
  module Feedback
    module Admin
      # A command to add a new recipient group.
      class UpdateRecipientGroup < Rectify::Command
        # Public: Initializes the command.
        #
        # form - The recipint group form.
        # group - The recipient group to update.
        def initialize(form, group)
          @form = form
          @group = group
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the handler wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          update_group!

          broadcast(:ok, group)
        end

        private

        attr_reader :group, :form

        def update_group!
          group.update!(
            name: form.name,
            recipient_emails: form.recipient_emails,
            metadata_conditions: form.metadata_conditions
          )
        end
      end
    end
  end
end
