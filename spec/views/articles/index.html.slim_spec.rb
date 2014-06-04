require 'spec_helper'

describe "articles/index" do
  before(:each) do
    assign(:articles, [
      stub_model(Article,
        :title => "Title",
        :guide_id => 1,
        :content => "MyText",
        :complete => "Complete"
      ),
      stub_model(Article,
        :title => "Title",
        :guide_id => 1,
        :content => "MyText",
        :complete => "Complete"
      )
    ])
  end

  it "renders a list of articles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Complete".to_s, :count => 2
  end
end
