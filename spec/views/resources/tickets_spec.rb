# frozen_string_literal: true

require "spec_helper"

RSpec.describe "ticket rendering" do
  let(:ticket) do
    ZdFinder::Search.call(
      resource_class: ZdFinder::Resource::Ticket,
      field: :_id,
      value: "436bf9b0-1147-4c0a-8439-6f79833bff5b"
    ).resources.first
  end
  let(:view) { ZdFinder::View.render("resources/tickets", resource: ticket) }

  it "displays the expected view" do
    expect(view.strip).to eq """
Ticket: #{ 'A Catastrophe in Korea (North)'.black.bold }

#{ 'ID: 436bf9b0-1147-4c0a-8439-6f79833bff5b, ' \
   'external_id: 9210cdc9-4bee-485f-a078-35396cd74063, ' \
   'url: http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json'
    .light_blue }

Properties:
-----------

Type: incident
Description: Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation \
amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.
Priority: high
Status: pending
Has incidents: #{ 'false'.red.bold }
Via: web
Due at:  2016-07-31 02:37:50 -1000


Meta:
-----

Created at: 2016-04-28 11:19:34 -1000
Tags:  Ohio, Pennsylvania, American Samoa, Northern Mariana Islands


Submitter:
--------

ID: 38
Name: Elma Castro
Email: georgettecastro@flotonic.com


Assigne:
--------

ID: 24
Name: Harris Côpeland
Email: gatescopeland@flotonic.com


Organization:
-------------

ID: 116
Name: Zentry


#{ '---------------------------------------------------------------------------------------' \
   '-------------'.black.bold }
    """.strip
  end
end
