require 'rails_helper'

RSpec.describe "doctors/index", type: :view do
  before(:each) do
    assign(:doctors, [
      Doctor.create!(
        name: "Name",
        image: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images"
      ),
      Doctor.create!(
        name: "Name",
        image: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images"
      )
    ])
  end

  it "renders a list of doctors" do
    render

    expect(rendered).to match /Name/
    # cell_selector = '.doctor-card'
    # assert_select cell_selector, text: /Name/, count: 2
    # assert_select cell_selector, text: Regexp.new("Image".to_s), count: 2
  end
end