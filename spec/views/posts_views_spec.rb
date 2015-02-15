require 'rails_helper'

describe "Post", type: :view do
    
  subject { page }  
  
  it_should_behave_like "index view", Post

  it_should_behave_like "show view", Post do
    let(:h1_text) { resource.title }
  end

  it_should_behave_like "new view", Post do
    let(:fill_ins) { { "Title" => "Title", "Content" => "Content." } }
  end
    
  pending "all post view specs."
  
  pending "final index layout."
  
  pending "final show layout."
  
end