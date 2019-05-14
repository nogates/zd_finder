# frozen_string_literal: true

module ZdFinder
  module Resource
    # The organization resource class.
    class Organization < Base
      @slug = "organizations"

      property :_id
      property :url
      property :external_id
      property :name
      property :domain_names
      property :created_at, transform_with: ->(value) { Time.parse(value) }
      property :details
      property :shared_tickets
      property :tags

      def users
        @users ||= User.where(:organization_id, _id)
      end

      def tickets
        @tickets ||= Ticket.where(:organization_id, _id)
      end
    end
  end
end
