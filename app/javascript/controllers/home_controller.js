import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "form", "grid",
    "min", "max", "minLabel", "maxLabel",
    "sliderRange", "thumbLeft", "thumbRight"
  ]

  connect() {
    this.initHomepage();
  }

  initHomepage() {
    this.minLabelTarget.textContent = this.minTarget.value;
    this.maxLabelTarget.textContent = this.maxTarget.value;
    this.enforceGap("min");
    this.enforceGap("max");
    this.updateSliderUI();
  }

  filterChanged(event) {
    this.minLabelTarget.textContent = this.minTarget.value
    this.maxLabelTarget.textContent = this.maxTarget.value

    if (event?.target === this.minTarget) {
      this.enforceGap("min")
    } else if (event?.target === this.maxTarget) {
      this.enforceGap("max")
    }

    this.updateSliderUI()
    this.submitForm()
  }

  submitForm() {
    if (this.submitTimeout) clearTimeout(this.submitTimeout)
    this.submitTimeout = setTimeout(() => {
      if (this.hasFormTarget) {
        const scrollPosition = window.pageYOffset
        this.formTarget.requestSubmit()
        setTimeout(() => {
          window.scrollTo(0, scrollPosition)
        }, 50)
      }
    }, 300)
  }

  enforceGap(source) {
    const gap = 10
    let min = parseInt(this.minTarget.value)
    let max = parseInt(this.maxTarget.value)

    if (max - min < gap) {
      if (source === "min") {
        min = max - gap
        this.minTarget.value = min
        this.minLabelTarget.textContent = min
      } else if (source === "max") {
        max = min + gap
        this.maxTarget.value = max
        this.maxLabelTarget.textContent = max
      }
    }
  }

  updateSliderUI() {
    const min = parseFloat(this.minTarget.value)
    const max = parseFloat(this.maxTarget.value)
    const rangeMin = parseFloat(this.minTarget.min)
    const rangeMax = parseFloat(this.maxTarget.max)

    const minPercent = ((min - rangeMin) / (rangeMax - rangeMin)) * 100
    const maxPercent = ((max - rangeMin) / (rangeMax - rangeMin)) * 100

    this.sliderRangeTarget.style.left = `${minPercent}%`
    this.sliderRangeTarget.style.right = `${100 - maxPercent}%`
    this.thumbLeftTarget.style.left = `${minPercent}%`
    this.thumbRightTarget.style.left = `${maxPercent}%`
  }
}
