# frozen_string_literal: true

class CreateDecidimFeedbackRecipientGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_feedback_recipient_groups do |t|
      t.integer(
        :decidim_organization_id,
        foreign_key: true,
        index: {
          name: "index_decidim_feedback_recipient_groups_on_organization_id"
        }
      )
      t.jsonb :name
      t.text :recipient_emails, array: true, default: []
      t.jsonb :metadata_conditions, default: {}
    end
  end
end
