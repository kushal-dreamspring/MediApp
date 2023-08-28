require 'rails_helper'

RSpec.describe InvoiceMailer, type: :mailer do
  fixtures :appointments

  let(:mail) { InvoiceMailer.with(appointment_id: appointments(:one).id).invoice_email }

  it 'renders the headers' do
    expect(mail.subject).to eq(I18n.t('invoice_mail.subject'))
    expect(mail.to).to include(appointments(:one).user.email)
    expect(mail.from).to include(InvoiceMailer::DEFAULT_SENDER_MAIL)
  end

  describe 'render the body' do
    it 'should contain the name of the doctor' do
      expect(mail.body.encoded).to include("Dr. #{appointments(:one).doctor.name}")
    end

    it 'should contain the link to the app' do
      expect(mail.body.encoded).to include("#{Rails.application.routes.default_url_options[:host]}/appointments/")
    end
  end
end
