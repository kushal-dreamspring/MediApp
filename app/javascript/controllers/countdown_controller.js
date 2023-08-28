import {Controller} from "@hotwired/stimulus"

let MILLISECOND_IN_SEC = 1000, SECS_IN_MIN = 60, MINS_IN_HR = SECS_IN_MIN, HOURS_IN_DAY = 24, DECIMAL_BASE = 10
export default class extends Controller {
    static targets = ["countdown", "time", "day", "hour", "minute", "second"]

    calculateCountdown(countdownTime) {
        let days = Math.floor(countdownTime / (MILLISECOND_IN_SEC * SECS_IN_MIN * MINS_IN_HR * HOURS_IN_DAY));
        let hours = Math.floor((countdownTime % (MILLISECOND_IN_SEC * SECS_IN_MIN * MINS_IN_HR * HOURS_IN_DAY)) / (MILLISECOND_IN_SEC * SECS_IN_MIN * MINS_IN_HR));
        let minutes = Math.floor((countdownTime % (MILLISECOND_IN_SEC * SECS_IN_MIN * MINS_IN_HR)) / (MILLISECOND_IN_SEC * SECS_IN_MIN));
        let seconds = Math.floor((countdownTime % (MILLISECOND_IN_SEC * SECS_IN_MIN)) / MILLISECOND_IN_SEC);

        return [days, hours, minutes, seconds];
    }

    countdown(appointmentTime) {
        this.x = setInterval(() => {
            const countdownTime = appointmentTime - new Date().getTime();

            const [days, hours, minutes, seconds] = this.calculateCountdown(countdownTime)

            this.dayTargets[0].innerHTML = Math.floor(days / DECIMAL_BASE);
            this.dayTargets[1].innerHTML = days % DECIMAL_BASE;
            this.hourTargets[0].innerHTML = Math.floor(hours / DECIMAL_BASE);
            this.hourTargets[1].innerHTML = hours % DECIMAL_BASE;
            this.minuteTargets[0].innerHTML = Math.floor(minutes / DECIMAL_BASE);
            this.minuteTargets[1].innerHTML = minutes % DECIMAL_BASE;
            this.secondTargets[0].innerHTML = Math.floor(seconds / DECIMAL_BASE);
            this.secondTargets[1].innerHTML = seconds % DECIMAL_BASE;

            if (countdownTime < 0) clearInterval(this.x);
        }, MILLISECOND_IN_SEC);
    }

    connect() {
        this.countdown(new Date(this.timeTarget.innerHTML).getTime())
    }

    disconnect() {
        clearInterval(this.x)
    }
}
