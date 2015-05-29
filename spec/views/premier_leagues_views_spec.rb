require 'rails_helper'

describe "PremierLeague", type: :view do
    
  subject { page }  

  it_should_behave_like "show view", PremierLeague do
    let(:h1_text) { resource.name }
  end

  it_should_behave_like "league table view", PremierLeague do
    let(:h1_text) { resource.name }
  end

end
