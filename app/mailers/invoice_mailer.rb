class InvoiceMailer < ApplicationMailer
  default from: 'kushalkhare.official@gmail.com'

  def invoice_email
    @appointment = Appointment.find_by(id: params[:appointment_id])
    @url = params[:url]

    return unless @appointment

    mail(to: @appointment.user.email, subject: 'MediApp: Thanks for booking an appointment with us')
  end
end
