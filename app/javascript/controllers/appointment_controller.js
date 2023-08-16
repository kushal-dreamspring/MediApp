import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["appointmentForm", "userForm", "paymentPage", "bookButton", "payButton"]

    connect() {
        this.appointmentFormTarget.classList.add('active')
    }

    enableBookButton() {
        this.bookButtonTarget.classList.remove('disabled', 'btn-info')
        this.bookButtonTarget.classList.add('btn-primary')
    }

    showUserForm() {
        this.appointmentFormTarget.classList.remove('active')
        this.userFormTarget.classList.add('active')
    }

    showLoader() {
        this.userFormTarget.classList.remove('active')
        this.paymentPageTarget.classList.add('active')
    }
}
