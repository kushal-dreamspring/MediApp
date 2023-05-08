import {Controller} from "@hotwired/stimulus"
import {min} from "@popperjs/core/lib/utils/math";

export default class extends Controller {
    static targets = ["countdown", "time", "day", "hour", "minute", "second"]

    calculateCountdown(countdownTime) {
        let days = Math.floor(countdownTime / (1000 * 60 * 60 * 24));
        let hours = Math.floor((countdownTime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        let minutes = Math.floor((countdownTime % (1000 * 60 * 60)) / (1000 * 60));
        let seconds = Math.floor((countdownTime % (1000 * 60)) / 1000);

        return [days, hours, minutes, seconds];
    }

    countdown(appointmentTime) {
        this.x = setInterval(() => {
            const countdownTime = appointmentTime - new Date().getTime();

            const [days, hours, minutes, seconds] = this.calculateCountdown(countdownTime)

            this.dayTargets[0].innerHTML = Math.floor(days / 10);
            this.dayTargets[1].innerHTML = days % 10;
            this.hourTargets[0].innerHTML = Math.floor(hours / 10);
            this.hourTargets[1].innerHTML = hours % 10;
            this.minuteTargets[0].innerHTML = Math.floor(minutes / 10);
            this.minuteTargets[1].innerHTML = minutes % 10;
            this.secondTargets[0].innerHTML = Math.floor(seconds / 10);
            this.secondTargets[1].innerHTML = seconds % 10;

            if (countdownTime < 0) clearInterval(this.x);
        }, 1000);
    }

    connect() {
        this.countdown(new Date(this.timeTarget.innerHTML).getTime())
    }

    disconnect() {
        clearInterval(this.x)
    }
}
