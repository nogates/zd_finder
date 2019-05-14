# frozen_string_literal: true

module ZdFinder
  module Resource
    # The user resource class.
    class User < Base
      @slug = "users"
      @indexed_fields = %i[organization_id]

      property :_id
      property :url
      property :external_id
      property :name
      property :alias
      property :created_at, transform_with: ->(value) { Time.parse(value) }
      property :active
      property :verified
      property :shared
      property :locale
      property :timezone
      property :last_login_at, transform_with: ->(value) { Time.parse(value) }
      property :email
      property :phone
      property :signature
      property :organization_id
      property :tags
      property :suspended
      property :role

      def organization
        @organization ||= Organization.find(organization_id)
      end

      def submitted_tickets
        @submitted_tickets ||= Ticket.where(:submitter_id, _id)
      end

      def assigned_tickets
        @assigned_tickets ||= Ticket.where(:assignee_id, _id)
      end
    end
  end
end
