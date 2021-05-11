# frozen_string_literal: true

require "rails_helper"

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "#fa_text" do
    it "returns the correct icon" do
      html = helper.fa_text :user_circle
      expect(html).to eq('<i class="fas fa-user-circle fa-fw " aria-hidden="true"></i>')
    end

    it "returns icon and text" do
      html = helper.fa_text :user_circle, "Circle"
      expect(html).to eq('<i class="fas fa-user-circle fa-fw " aria-hidden="true"></i>&nbsp;Circle')
    end

    it "returns with additional style" do
      html = helper.fa_text :user_circle, class_name: "text-danger"
      expect(html).to eq('<i class="fas fa-user-circle fa-fw text-danger" aria-hidden="true"></i>')
    end

    it "returns styled icon" do
      html = helper.fa_text :user_circle, style: "vertical-align: middle;"
      expect(html).to eq('<i class="fas fa-user-circle fa-fw " style="vertical-align: middle;" aria-hidden="true"></i>')
    end
  end

  describe "#show_sex_symbol" do
    it "just symbol Male" do
      html = helper.show_sex_symbol true
      expect(html).to eq('<i class="fas fa-male"></i>')
    end

    it "just symbol Female" do
      html = helper.show_sex_symbol false
      expect(html).to eq('<i class="fas fa-female female-color"></i>')
    end

    it "with text" do
      html = helper.show_sex_symbol true, show_text: true
      expect(html).to match('<i class="fas fa-male"></i>&nbsp;.*')
    end
  end
end
