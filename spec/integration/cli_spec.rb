# frozen_string_literal: true

require "spec_helper"

RSpec.describe "cli integration tests" do
  let(:arguments) { [ "-r", resource, "-f", field, "-v", value ] }
  subject { ZdFinder::Cli.new.call }

  before { stub_const("ARGV", arguments.compact) }

  describe "searching for tickets" do
    let(:resource) { "tickets" }

    context "when searching by a valid field" do
      let(:field) { "_id" }

      context "when there is a ticket with that id" do
        let(:value) { "436bf9b0-1147-4c0a-8439-6f79833bff5b" }

        it "finds the ticket with that id, and only that ticket" do
          expect { subject }.to output(/1 tickets found/).to_stdout
        end

        it "includes the main info of the ticket" do
          info = "ID: 436bf9b0-1147-4c0a-8439-6f79833bff5b, " \
                 "external_id: 9210cdc9-4bee-485f-a078-35396cd74063, " \
                 "url: http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json"

          expect { subject }.to output(/#{ info }/).to_stdout
        end
      end

      context "when there is not a ticket with that id" do
        let(:value) { "invalid_id" }

        it "does not find any ticket" do
          expect { subject }.to output(/No tickets could be found/).to_stdout
        end
      end

      context "when the search returns multiple tickets" do
        let(:field) { "type" }
        let(:value) { "incident" }

        it "returns all the tickets that can be found" do
          expect { subject }.to output(/35 tickets found/).to_stdout
        end
      end

      context "when searching on an array field" do
        let(:field) { "tags" }
        let(:value) { "Georgia" }

        it "still matches the value inside the array" do
          expect { subject }.to output(/14 tickets found/).to_stdout
        end
      end
    end

    context "when searching by an invalid field" do
      let(:field) { "i dont exist" }
      let(:value) { "" }

      it "does not allow to select an invalid field" do
        expect { subject }
          .to output(/The field `i dont exist` does not belong to `tickets`/)
          .to_stderr
          .and raise_error(SystemExit)
      end
    end
  end

  describe "searching for organizations" do
    let(:resource) { "organizations" }

    context "when searching by a valid field" do
      let(:field) { "_id" }

      context "when there is a organization with that id" do
        let(:value) { "101" }

        it "finds the organization with that id and just that organization" do
          expect { subject }.to output(/1 organizations found/).to_stdout
        end

        it "includes the main info of the organization" do
          info = "ID: 101, " \
                 "external_id: 9270ed79-35eb-4a38-a46f-35725197ea8d, " \
                 "url: http://initech.zendesk.com/api/v2/organizations/101.json"

          expect { subject }.to output(/#{ info }/).to_stdout
        end
      end

      context "when there is not an organization with that id" do
        let(:value) { "999999" }

        it "does not find any organization" do
          expect { subject }.to output(/No organizations could be found/).to_stdout
        end
      end

      context "when the search returns multiple organizations" do
        let(:field) { "shared_tickets" }
        let(:value) { "false" }

        it "returns all the organizations that can be found" do
          expect { subject }.to output(/15 organizations found/).to_stdout
        end
      end
    end

    context "when searching on an array field" do
      let(:field) { "domain_names" }
      let(:value) { "kage.com" }

      it "still matches the value inside the array" do
        expect { subject }.to output(/1 organizations found/).to_stdout
      end
    end

    context "when searching by an invalid field and then quitting" do
      let(:field) { "i dont exist" }
      let(:value) { "" }

      let(:context_keys) { [ "i dont exist", "quit" ] }

      it "does not allow to select an invalid field" do
        expect { subject }
          .to output(/The field `i dont exist` does not belong to `organizations`/)
          .to_stderr
          .and raise_error(SystemExit)
      end
    end
  end

  describe "searching for users" do
    let(:resource) { "users" }

    context "when searching by a valid field" do
      let(:field) { "_id" }

      context "when there is a ticket with that id" do
        let(:value) { "1" }

        it "finds the user with that id and only that user" do
          expect { subject }.to output(/1 users found/).to_stdout
        end

        it "includes the main info of the organization" do
          info = "ID: 1, " \
                 "external_id: 74341f74-9c79-49d5-9611-87ef9b6eb75f, " \
                 "url: http://initech.zendesk.com/api/v2/users/1.json"

          expect { subject }.to output(/#{ info }/).to_stdout
        end
      end

      context "when there is not a user with that id" do
        let(:value) { "999999" }

        it "does not find any user" do
          expect { subject }.to output(/No users could be found/).to_stdout
        end
      end

      context "when the search returns multiple users" do
        let(:field) { "active" }
        let(:value) { "true" }

        it "returns all the users that can be found" do
          expect { subject }.to output(/39 users found/).to_stdout
        end
      end
    end

    context "when searching on an array field" do
      let(:field) { "tags" }
      let(:value) { "National" }

      it "still matches the value inside the array" do
        expect { subject }.to output(/1 users found/).to_stdout
      end
    end

    context "when searching by an invalid field and then quitting" do
      let(:field) { "i dont exist" }
      let(:value) { "" }

      it "does not allow to select an invalid field" do
        expect { subject }
          .to output(/The field `i dont exist` does not belong to `users`/)
          .to_stderr
          .and raise_error(SystemExit)
      end
    end
  end

  describe "displaying the help" do
    let(:arguments) { [ "-h" ] }

    it "shows information about the command usage" do
      expect { subject }
        .to output(/Welcome to ZD Finder. Usage: zd_finder \[options\]/)
        .to_stdout
        .and raise_error(SystemExit)
    end
  end

  describe "displaying the available fields" do
    let(:arguments) { [ "-l" ] }

    it "does include all the fields that can be used to search tickets" do
      ticket_fields = "Tickets\n  -------\n\n  _id assignee_id created_at description " \
                      "due_at external_id has_incidents organization_id priority status " \
                      "subject submitter_id tags type url via"

      expect { subject }
        .to output(/#{ ticket_fields }/).to_stdout.and raise_error(SystemExit)
    end

    it "does include all the fields that can be used to search organizations" do
      ticket_fields = "Organizations\n  -------------\n\n  _id created_at details " \
                      "domain_names external_id name shared_tickets tags url"

      expect { subject }
        .to output(/#{ ticket_fields }/).to_stdout.and raise_error(SystemExit)
    end

    it "does include all the fields that can be used to search users" do
      ticket_fields = "Users\n  -----\n\n  _id active alias created_at email external_id " \
                      "last_login_at locale name organization_id phone role shared " \
                      "signature suspended tags timezone url verified"

      expect { subject }
        .to output(/#{ ticket_fields }/).to_stdout.and raise_error(SystemExit)
    end
  end

  describe "only valid options are allowed" do
    context "when the user passess an invalid resource" do
      let(:resource) { "groups" }
      let(:field) { "_id" }
      let(:value) { "1" }

      it "shows that the option is invalid" do
        expect { subject }
          .to output(/invalid option: Invalid resource `groups`/)
          .to_stderr
          .and raise_error(SystemExit)
      end
    end

    context "when the user passes an empty resource" do
      let(:arguments) { [ "-r" ] }

      it "displays the missing argument error" do
        expect { subject }
          .to output(/missing argument: -r/)
          .to_stderr
          .and raise_error(SystemExit)
      end
    end

    context "when the user passes an empty field" do
      let(:arguments) { [ "-r", "tickets", "-f" ] }

      it "displays the missing argument error" do
        expect { subject }
          .to output(/missing argument: -f/)
          .to_stderr
          .and raise_error(SystemExit)
      end
    end

    context "when the user enters an empty value" do
      let(:arguments) { [ "-r", "tickets", "-f", "assignee_id", "-v" ] }

      it "empty values are valid and must return records" do
        expect { subject }.to output(/4 tickets found/).to_stdout
      end
    end
  end

  describe "the search generates an error" do
    let(:resource) { "users" }
    let(:field) { "_id" }
    let(:value) { "1" }

    before do
      allow(ZdFinder::Resource::User).to receive(:where)
        .and_raise(StandardError.new("Undefined error"))
    end

    it "renders the error in the output" do
      expect { subject }
        .to output(
          /There was an error when fetching data from the collection: Undefined error/
        ).to_stdout
    end
  end
end
