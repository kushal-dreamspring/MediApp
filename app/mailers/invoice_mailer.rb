class InvoiceMailer < ApplicationMailer
  DEFAULT_SENDER_MAIL = 'kushalkhare.official@gmail.com'
  helper :appointments

  default from: DEFAULT_SENDER_MAIL

  def invoice_email
    @appointment = Appointment.find_by(id: params[:appointment_id])

    return unless @appointment

    mail(to: @appointment.user.email, subject: I18n.t('medi_app_thanks_for_booking_an_appointment_with_us'))
  end
end
