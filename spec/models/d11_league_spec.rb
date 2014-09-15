require 'rails_helper'

describe D11League, type: :model do
  
  let(:season) { FactoryGirl.create(:season, name: "2000-2001") }
  
  before { @d11_league = FactoryGirl.create(:d11_league, season: season, name: "Drömelvan") }
  
  subject { @d11_league }
  
  it { is_expected.to respond_to(:season) }
  it { is_expected.to respond_to(:name) }  
  
  it { is_expected.to be_valid }
  
  describe '#season' do
    subject { @d11_league.season }
    it { is_expected.to eq season }
  end

  describe '#name' do
    subject { @d11_league.name }
    it { is_expected.to eq "Drömelvan" }
  end
  
  describe '.current' do
    before { D11League.destroy_all }
    before { Season.destroy_all }
    
    let!(:season1) { FactoryGirl.create(:season, date: Date.today - 1.day) }
    let!(:season2) { FactoryGirl.create(:season, date: Date.today) }
    let!(:d11_league1) { FactoryGirl.create(:d11_league, season: season1) }
    let!(:d11_league2) { FactoryGirl.create(:d11_league, season: season2) }
    
    specify { expect(D11League.current).to eq d11_league2 }
  end
  
  it_should_behave_like "season unique named"
   
  context "when season is nil" do
    before { @d11_league.season = nil }
    it { is_expected.not_to be_valid }
  end
  
  context "when name is blank" do
    before { @d11_league.name = "" }
    it { is_expected.not_to be_valid }
  end
  
end