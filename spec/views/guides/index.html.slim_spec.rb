require 'spec_helper'

describe "guides/index" do
  before(:each) do
    assign(:guides, [
      stub_model(Guide,
        :title => "Title",
        :user_id => 1,
        :category_id => 2,
        :subtitle => "Subtitle",
        :overview => "Overview",
        :img => "Img",
        :publish => false,
        :feature_id => 3
      ),
      stub_model(Guide,
        :title => "Title",
        :user_id => 1,
        :category_id => 2,
        :subtitle => "Subtitle",
        :overview => "Overview",
        :img => "Img",
        :publish => false,
        :feature_id => 3
      )
    ])
  end

  it "renders a list of guides" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Subtitle".to_s, :count => 2
    assert_select "tr>td", :text => "Overview".to_s, :count => 2
    assert_select "tr>td", :text => "Img".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
