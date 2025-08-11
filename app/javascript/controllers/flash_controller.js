import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alert"]

  connect() {
    this.autoDismissAllAlerts()
  }

  autoDismissAllAlerts() {
    this.alertTargets.forEach(alert => {
      if (alert.dismissTimeout) {
        clearTimeout(alert.dismissTimeout)
      }

      alert.dismissTimeout = setTimeout(() => {
        if (alert && alert.parentNode && !alert.classList.contains('fade-out')) {
          alert.classList.add('fade-out')
          const bsAlert = new bootstrap.Alert(alert)
          bsAlert.close()
        }
      }, 3000)
    })
  }

  disconnect() {
    this.alertTargets.forEach(alert => {
      if (alert.dismissTimeout) {
        clearTimeout(alert.dismissTimeout)
      }
    })
  }

}
