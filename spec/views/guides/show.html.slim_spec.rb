require 'spec_helper'

describe "guides/show" do
  before(:each) do
    @guide = assign(:guide, stub_model(Guide,
      :title => "Title",
      :user_id => 1,
      :category_id => 2,
      :subtitle => "Subtitle",
      :overview => "Overview",
      :img => "Img",
      :publish => false,
      :feature_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Subtitle/)
    rendered.should match(/Overview/)
    rendered.should match(/Img/)
    rendered.should match(/false/)
    rendered.should match(/3/)
  end
end
