import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "options"]

  select(e) {
    e.preventDefault()

    const li = e.currentTarget
    const value = li.dataset.value
    this.inputTarget.value = value
    this.submitFormWithoutScroll()
  }

  submitFormWithoutScroll() {
    const form = this.element.closest("form")
    if (form) {
      const scrollPosition = window.pageYOffset
      form.requestSubmit()
      setTimeout(() => {
        window.scrollTo(0, scrollPosition)
      }, 50)
    }
  }
}
