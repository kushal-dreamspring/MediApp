import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["selectedDate"]

    connect() {
        this.selectedDateTarget.innerHTML = new Date().toDateString()
    }

    setDate(event) {
        this.selectedDateTarget.innerHTML = new Date(event.target.attributes['value'].value).toDateString()
    }
}
