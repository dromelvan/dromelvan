require 'rails_helper'

describe "TransferDay", type: :view do
  
  subject { page }

  it_should_behave_like "show view", TransferDay do
    let(:h1_text) { resource.name }
  end
  
end
