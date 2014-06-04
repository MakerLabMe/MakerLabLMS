require 'spec_helper'

describe "articles/new" do
  before(:each) do
    assign(:article, stub_model(Article,
      :title => "MyString",
      :guide_id => 1,
      :content => "MyText",
      :complete => "MyString"
    ).as_new_record)
  end

  it "renders new article form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => articles_path, :method => "post" do
      assert_select "input#article_title", :name => "article[title]"
      assert_select "input#article_guide_id", :name => "article[guide_id]"
      assert_select "textarea#article_content", :name => "article[content]"
      assert_select "input#article_complete", :name => "article[complete]"
    end
  end
end
