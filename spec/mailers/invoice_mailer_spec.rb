require 'rails_helper'

RSpec.describe InvoiceMailer, type: :mailer do
  fixtures :appointments

  let(:mail) { InvoiceMailer.with(appointment_id: appointments(:one).id).invoice_email }

  it 'renders the headers' do
    expect(mail.subject).to eq(I18n.t('medi_app_thanks_for_booking_an_appointment_with_us'))
    expect(mail.to).to include(appointments(:one).user.email)
    expect(mail.from).to include(InvoiceMailer::DEFAULT_SENDER_MAIL)
  end
end
