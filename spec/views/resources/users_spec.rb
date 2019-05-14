# frozen_string_literal: true

require "spec_helper"

RSpec.describe "ticket rendering" do
  let(:user) do
    ZdFinder::Search.call(
      resource_class: ZdFinder::Resource::User,
      field: :_id,
      value: "1"
    ).resources.first
  end
  let(:view) { ZdFinder::View.render("resources/users", resource: user) }

  it "displays the expected view" do
    expect(view.strip).to eq """
User: #{ 'Francisca Rasmussen'.black.bold }

#{ 'ID: 1, external_id: 74341f74-9c79-49d5-9611-87ef9b6eb75f, ' \
   'url: http://initech.zendesk.com/api/v2/users/1.json'
    .light_blue }

Properties:
-----------

Alias: Miss Coffey
Email: coffeyrasmussen@flotonic.com
Phone: 8335-422-718
Signature: Don't Worry Be Happy!
Role: admin
Active: #{ 'true'.green.bold }
Verified: #{ 'true'.green.bold }
Shared: #{ 'false'.red.bold }
Suspended: #{ 'true'.green.bold }
Locale: en-AU
Timezone: en-AU
Last login at: 2013-08-04 01:03:27 -1000


Meta:
-----

Created at: 2016-04-15 05:19:46 -1000
Tags:  Springville, Sutton, Hartsville/Hartley, Diaperville


Organization:
------------

ID: 119
Name: Multron


Submitted tickets:
-----------------

- Subject: A Nuisance in Kiribati, ID: fc5a8a70-3814-4b17-a6e9-583936fca909

- Subject: A Nuisance in Saint Lucia, ID: cb304286-7064-4509-813e-edc36d57623d


Assigned tickets:
-----------------

- Subject: A Problem in Russian Federation, ID: 1fafaa2a-a1e9-4158-aeb4-f17e64615300

- Subject: A Problem in Malawi, ID: 13aafde0-81db-47fd-b1a2-94b0015803df


#{ '---------------------------------------------------------------------------------------' \
   '-------------'.black.bold }
    """.strip
  end
end
