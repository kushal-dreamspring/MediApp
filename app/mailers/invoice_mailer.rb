class InvoiceMailer < ApplicationMailer
  DEFAULT_SENDER_MAIL = 'kushalkhare.official@gmail.com'
  helper :appointments

  default from: DEFAULT_SENDER_MAIL

  def invoice_email
    @appointment = Appointment.find_by(id: params[:appointment_id])

    return unless @appointment

    mail(to: @appointment.user.email, subject: I18n.t('invoice_mail.subject'))
  end
end
