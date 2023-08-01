require 'rails_helper'

RSpec.describe InvoiceMailer, type: :mailer do
  fixtures :appointments

  let(:mail) { InvoiceMailer.with(appointment_id: appointments(:one).id, pdf: 'https://mediapp.com/appointments/1.pdf').invoice_email }

  it 'renders the headers' do
    expect(mail.subject).to eq('MediApp: Thanks for booking an appointment with us')
    expect(mail.to).to eq(['johndoe@test.com'])
    expect(mail.from).to eq(['kushalkhare.official@gmail.com'])
  end

  # it "renders the body" do
  #   expect(mail.body.encoded).to match("Hi")
  # end
end
