import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["appointmentForm", "userForm", "bookButton"]

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
}
