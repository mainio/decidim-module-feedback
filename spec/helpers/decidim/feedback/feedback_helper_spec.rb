# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Feedback
    describe FeedbackHelper do
      describe "#render" do
        subject do
          Nokogiri::HTML(helper.feedback_modal(dummy_resource, options))
        end

        let(:dummy_resource) { create(:dummy_resource) }
        let(:cell) { double }
        let!(:user) { create(:user) }
        let(:options) { { modal_id: dummy_resource.id } }

        before do
          allow(Decidim::Feedback::FeedbackModalCell).to receive(:current_user).and_return(user)
        end

        it "shows feedback modal" do
          expect(cell).to receive(:to_s)

          allow(helper)
            .to receive(:cell)
            .with(
              "decidim/feedback/feedback_modal",
              dummy_resource,
              options
            ).and_return(cell)

          helper.feedback_modal(dummy_resource, options)
        end

        context "when there is cell" do
          let(:cell) { "<div>something</div>" }

          it "triggers feedback modal" do
            allow(helper)
              .to receive(:feedback_modal)
              .with(
                dummy_resource,
                options
              ).and_return(cell)

            expect(helper.trigger_feedback_modal(dummy_resource, options)).to eq("<div>something</div>")
          end
        end
      end
    end
  end
end
