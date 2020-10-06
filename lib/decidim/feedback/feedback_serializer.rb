# frozen_string_literal: true

module Decidim
  module Feedback
    # This class serializes a Feedback so can be exported to CSV, JSON or other
    # formats.
    class FeedbackSerializer < Decidim::Exporters::Serializer
      # Public: Initializes the serializer with a feedback.
      def initialize(feedback)
        @feedback = feedback
      end

      # Public: Exports a hash with the serialized data for this proposal.
      def serialize
        {
          id: feedback.id,
          source: serialize_source,
          user: serialize_user,
          rating: feedback.rating,
          body: feedback.body,
          contact_request: feedback.contact_request,
          metadata: feedback.metadata
        }
      end

      private

      attr_reader :feedback

      def serialize_user
        return { id: nil, name: nil, profile_url: nil } if user.blank? || user.deleted?

        {
          id: feedback.user.id,
          name: feedback.user.name,
          profile_url: decidim.profile_url(feedback.user.nickname)
        }
      end

      def serialize_source
        return { name: nil, id: nil, link: nil } unless feedback.feedbackable

        {
          name: feedback.feedbackable.class.model_name.human(count: 2),
          id: feedback.feedbackable.id,
          link: Decidim::ResourceLocatorPresenter.new(feedback.feedbackable).url
        }
      end

      def decidim
        Decidim::Core::Engine.routes.url_helpers
      end
    end
  end
end
