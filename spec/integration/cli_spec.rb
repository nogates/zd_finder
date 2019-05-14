# frozen_string_literal: true

require "spec_helper"

RSpec.describe "cli integration tests" do
  subject { ZdFinder::Cli.new.call }

  before do
    allow($stdin).to receive(:gets).and_return(*keys_combination)
  end

  describe "searching for tickets" do
    let(:keys_combination) { [ "", "1", "1" ] + context_keys }

    context "when searching by a valid field" do
      let(:context_keys) { [ "_id", ticket_id ] }

      context "when there is a ticket with that id" do
        let(:ticket_id) { "436bf9b0-1147-4c0a-8439-6f79833bff5b" }

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
        let(:ticket_id) { "invalid id" }

        it "does not find any ticket" do
          expect { subject }.to output(/No tickets could be found/).to_stdout
        end
      end

      context "when the search returns multiple tickets" do
        let(:context_keys) { %w[type incident] }

        it "returns all the tickets that can be found" do
          expect { subject }.to output(/35 tickets found/).to_stdout
        end
      end

      context "when searching on an array field" do
        let(:context_keys) { %w[tags Georgia] }

        it "still matches the value inside the array" do
          expect { subject }.to output(/14 tickets found/).to_stdout
        end
      end
    end

    context "when searching by an invalid field and then quitting" do
      let(:context_keys) { [ "i dont exist", "quit" ] }

      it "does not allow to select an invalid field" do
        expect { subject }
          .to output(/Sorry, invalid option: `i dont exist`/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end
  end

  describe "searching for organizations" do
    let(:keys_combination) { [ "", "1", "2" ] + context_keys }

    context "when searching by a valid field" do
      let(:context_keys) { [ "_id", organization_id ] }

      context "when there is a organization with that id" do
        let(:organization_id) { "101" }

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
        let(:organization_id) { "999999" }

        it "does not find any organization" do
          expect { subject }
            .to output(/No organizations could be found/).to_stdout
        end
      end

      context "when the search returns multiple organizations" do
        let(:context_keys) { %w[shared_tickets false] }

        it "returns all the organizations that can be found" do
          expect { subject }.to output(/15 organizations found/).to_stdout
        end
      end
    end

    context "when searching on an array field" do
      let(:context_keys) { [ "domain_names", "kage.com" ] }

      it "still matches the value inside the array" do
        expect { subject }.to output(/1 organizations found/).to_stdout
      end
    end

    context "when searching by an invalid field and then quitting" do
      let(:context_keys) { [ "i dont exist", "quit" ] }

      it "does not allow to select an invalid field" do
        expect { subject }
          .to output(/Sorry, invalid option: `i dont exist`/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end
  end

  describe "searching for users" do
    let(:keys_combination) { [ "", "1", "3" ] + context_keys }

    context "when searching by a valid field" do
      let(:context_keys) { [ "_id", user_id ] }

      context "when there is a ticket with that id" do
        let(:user_id) { "1" }

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
        let(:user_id) { "999999" }

        it "does not find any user" do
          expect { subject }.to output(/No users could be found/).to_stdout
        end
      end

      context "when the search returns multiple users" do
        let(:context_keys) { %w[active true] }

        it "returns all the users that can be found" do
          expect { subject }.to output(/39 users found/).to_stdout
        end
      end
    end

    context "when searching on an array field" do
      let(:context_keys) { %w[tags National] }

      it "still matches the value inside the array" do
        expect { subject }.to output(/1 users found/).to_stdout
      end
    end

    context "when searching by an invalid field and then quitting" do
      let(:context_keys) { [ "i dont exist", "quit" ] }

      it "does not allow to select an invalid field" do
        expect { subject }
          .to output(/Sorry, invalid option: `i dont exist`/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end
  end

  describe "displaying the available fields" do
    let(:keys_combination) { [ "", "2" ] }

    it "does include all the fields that can be used to search tickets" do
      ticket_fields = "Tickets\n  -------\n\n  _id assignee_id created_at " \
                      "description due_at external_id has_incidents " \
                      "organization_id priority status subject submitter_id " \
                      "tags type url via"

      expect { subject }.to output(/#{ ticket_fields }/).to_stdout
    end

    it "does include all the fields that can be used to search organizations" do
      ticket_fields = "Organizations\n  -------------\n\n  _id created_at " \
                      "details domain_names external_id name shared_tickets " \
                      "tags url"

      expect { subject }.to output(/#{ ticket_fields }/).to_stdout
    end

    it "does include all the fields that can be used to search users" do
      ticket_fields = "Users\n  -----\n\n  _id active alias created_at email " \
                      "external_id last_login_at locale name organization_id " \
                      "phone role shared signature suspended tags timezone " \
                      "url verified"

      expect { subject }.to output(/#{ ticket_fields }/).to_stdout
    end
  end

  describe "user can quit at anytime" do
    context "when quitting at the intro menu" do
      let(:keys_combination) { [ "quit" ] }

      it "shows the first menu and exists the program" do
        expect { subject }
          .to output(/Welcome to ZD Finder/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end

    context "when quitting at the main menu" do
      let(:keys_combination) { [ "", "quit" ] }

      it "shows the intro and the main menu and exists the program" do
        expect { subject }
          .to output(/Type `quit` to exit/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end

    context "when quitting at the resource menu" do
      let(:keys_combination) { [ "", "1", "quit" ] }

      it "shows the intro, main and resource menu and then exists" do
        expect { subject }
          .to output(/Select: 1\) Tickets or 2\) Organizations or 3\) Users/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end

    context "when quitting at the field menu" do
      let(:keys_combination) { [ "", "1", "1", "quit" ] }

      it "shows the intro, main, resource and field menu and then exists" do
        expect { subject }
          .to output(/Enter search field/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end

    context "when quitting at the value menu" do
      let(:keys_combination) { [ "", "1", "1", "_id", "quit" ] }

      it "shows all the menus and then exists" do
        expect { subject }
          .to output(/Enter search value/)
          .to_stdout
          .and raise_error(SystemExit)
      end
    end
  end

  describe "only valid options are allowed" do
    context "when the user selects an invalid option on the main menu" do
      let(:keys_combination) { [ "", "invalid", "quit" ] }

      it "shows that the option is invalid" do
        expect { subject }
          .to output(
            /Sorry, invalid option: `invalid`.\nYou must select one of: 1, 2, quit/
          ).to_stdout.and raise_error(SystemExit)
      end
    end

    context "when the user selects an invalid option on the resource menu" do
      let(:keys_combination) { [ "", "1", "invalid resource", "quit" ] }

      it "shows that the option is invalid" do
        expect { subject }
          .to output(
            /Sorry, invalid option: `invalid resource`.\nYou must select one of: 1, 2, 3, quit/
          ).to_stdout.and raise_error(SystemExit)
      end
    end

    context "when the user enters an empty value" do
      let(:keys_combination) { [ "", "1", "1", "assignee_id", "" ] }

      it "empty values are valid and must return records" do
        expect { subject }.to output(/4 tickets found/).to_stdout
      end
    end
  end

  describe "the search generates an error" do
    let(:keys_combination) { [ "", "1", "1", "_id", "101" ] }

    before do
      allow(ZdFinder::Resource::Ticket).to receive(:where)
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
