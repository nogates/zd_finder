# frozen_string_literal: true

require "spec_helper"

RSpec.describe "ticket rendering" do
  let(:organization) do
    ZdFinder::Search.call(
      resource_class: ZdFinder::Resource::Organization,
      field: :_id,
      value: "101"
    ).resources.first
  end
  let(:view) { ZdFinder::View.render("resources/organizations", resource: organization) }

  it "displays the expected view" do
    expect(view.strip).to eq """
Organization: #{ 'Enthaze'.black.bold }

#{ 'ID: 101, external_id: 9270ed79-35eb-4a38-a46f-35725197ea8d, ' \
   'url: http://initech.zendesk.com/api/v2/organizations/101.json'
    .light_blue }

Properties:
-----------

Domain names: kage.com, ecratic.com, endipin.com, zentix.com
Detail: MegaCorp
Shared Tickets: #{ 'false'.red.bold }


Meta:
-----

Created at: 2016-05-21 11:10:28 -1000
Tags:  Fulton, West, Rodriguez, Farley


Users:
------

- Name: Loraine Pittman, Email: olapittman@flotonic.com, ID: 5

- Name: Francis Bailey, Email: singletonbailey@flotonic.com, ID: 23

- Name: Haley Farmer, Email: lizziefarmer@flotonic.com, ID: 27

- Name: Herrera Norman, Email: vancenorman@flotonic.com, ID: 29


Tickets:
------

- Subject: A Drama in Portugal, ID: b07a8c20-2ee5-493b-9ebf-f6321b95966e

- Subject: A Problem in Ethiopia, ID: c22aaced-7faa-4b5c-99e5-1a209500ff16

- Subject: A Problem in Turks and Caicos Islands, ID: 89255552-e9a2-433b-970a-af194b3a39dd

- Subject: A Problem in Guyana, ID: 27c447d9-cfda-4415-9a72-d5aa12942cf1


#{ '---------------------------------------------------------------------------------------' \
   '-------------'.black.bold }
    """.strip
  end
end
