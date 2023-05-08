import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["appointmentForm", "userForm"]

    connect() {
        this.appointmentFormTarget.classList.add('active')
    }

    showUserForm() {
        this.appointmentFormTarget.classList.remove('active')
        this.userFormTarget.classList.add('active')
    }
}
