# frozen_string_literal: true

module ZdFinder
  module Resource
    # The ticket resource class.
    class Ticket < Base
      @slug = "tickets"
      @indexed_fields = %i[submitter_id assignee_id organization_id]

      property :_id
      property :url
      property :external_id
      property :created_at, transform_with: ->(value) { Time.parse(value) }
      property :type
      property :subject
      property :description
      property :priority
      property :status
      property :submitter_id
      property :assignee_id
      property :organization_id
      property :tags
      property :has_incidents
      property :due_at, transform_with: ->(value) { Time.parse(value) }
      property :via

      def assignee
        @assignee ||= User.find(assignee_id)
      end

      def submitter
        @submitter ||= User.find(submitter_id)
      end

      def organization
        @organization ||= Organization.find(organization_id)
      end
    end
  end
end
