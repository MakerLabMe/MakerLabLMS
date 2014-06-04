require 'spec_helper'

describe "guides/new" do
  before(:each) do
    assign(:guide, stub_model(Guide,
      :title => "MyString",
      :user_id => 1,
      :category_id => 1,
      :subtitle => "MyString",
      :overview => "MyString",
      :img => "MyString",
      :publish => false,
      :feature_id => 1
    ).as_new_record)
  end

  it "renders new guide form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => guides_path, :method => "post" do
      assert_select "input#guide_title", :name => "guide[title]"
      assert_select "input#guide_user_id", :name => "guide[user_id]"
      assert_select "input#guide_category_id", :name => "guide[category_id]"
      assert_select "input#guide_subtitle", :name => "guide[subtitle]"
      assert_select "input#guide_overview", :name => "guide[overview]"
      assert_select "input#guide_img", :name => "guide[img]"
      assert_select "input#guide_publish", :name => "guide[publish]"
      assert_select "input#guide_feature_id", :name => "guide[feature_id]"
    end
  end
end
