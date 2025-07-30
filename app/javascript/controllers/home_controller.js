import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "grid", "category", "sort", "veg",
    "min", "max", "minLabel", "maxLabel",
    "sliderRange", "thumbLeft", "thumbRight"
  ]

  connect() {
    console.log("✅ Home controller connected")

    this.items = Array.isArray(window.foodItems) ? window.foodItems : []

    this.minLabelTarget.textContent = this.minTarget.value
    this.maxLabelTarget.textContent = this.maxTarget.value

    this.enforceGap("min")
    this.enforceGap("max")
    this.updateSliderUI()
    this.applyFilters()
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
    this.applyFilters(event)
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

  applyFilters(event) {
    if (event && event.target.tagName === "LI") {
      const dropdown = event.target.closest(".custom-dropdown")
      const label = dropdown.querySelector(".dropdown-label")

      if (dropdown.id === "category-dropdown") {
        label.textContent = event.target.textContent.trim()
      } else if (dropdown.id === "sort-dropdown") {
        label.textContent = event.target.textContent.trim()
      }
    }

    const selectedCategory = this.categoryTarget.querySelector(".dropdown-label").textContent.trim()
    const selectedSort     = this.sortTarget.querySelector(".dropdown-label").textContent.trim()
    const minPrice         = parseFloat(this.minTarget.value)
    const maxPrice         = parseFloat(this.maxTarget.value)
    const onlyVeg          = this.vegTarget.checked

    let items = [...this.items]

    // Category filter
    if (selectedCategory !== "All" && selectedCategory !== "Category") {
      items = items.filter(i => i.category === selectedCategory)
    }

    // Sorting
    if (selectedSort === "Price: Low to High") {
      items.sort((a, b) => a.price - b.price)
    } else if (selectedSort === "Price: High to Low") {
      items.sort((a, b) => b.price - a.price)
    }

    // Vegetarian filter
    if (onlyVeg) {
      items = items.filter(i => i.vegetarian)
    }

    // Price filter
    items = items.filter(i => i.price >= minPrice && i.price <= maxPrice)

    this.renderGrid(items)
  }

  renderGrid(items) {
    this.gridTarget.innerHTML = ""

    if (items.length === 0) {
      this.gridTarget.innerHTML = "<p>No items match your filters.</p>"
      return
    }

    for (const item of items) {
      const card = document.createElement("div")
      card.className = "food-card"
      card.innerHTML = `
        <img src="${item.img}" alt="${item.name}" />
        <h3>${item.name}</h3>
        <p>${item.category}</p>
        <strong>$${item.price.toFixed(2)}</strong>
      `
      this.gridTarget.appendChild(card)
    }
  }
}
