import { Controller } from "@hotwired/stimulus"
import "../constants" // provides window.foodItems

export default class extends Controller {
  connect() {
    console.log("Home page controller connected");

    this.FOOD_ITEMS_STORAGE_KEY = 'eurekaCaffeMenuItems';
    this.selectedCategory = "All";
    this.selectedSort = "default";

    this.getElements();
    this.initFoodItems();
    this.populateCategoryDropdown();
    this.renderGrid(this.displayedFoodItems);
    this.setupListeners();
    this.setupPriceRangeSlider();
  }

  getElements() {
    this.grid = document.getElementById("food-grid");
    this.categoryDropdown = document.getElementById("category-dropdown");
    this.sortDropdown = document.getElementById("sort-dropdown");
    this.vegetarianToggle = document.getElementById("vegetarian-toggle");
    this.priceRangeMin = document.getElementById("price-range-min");
    this.priceRangeMax = document.getElementById("price-range-max");
    this.minPriceLabel = document.querySelector(".min-price");
    this.maxPriceLabel = document.querySelector(".max-price");
    this.sliderRange = document.querySelector(".slider-range");
    this.thumbLeft = document.querySelector(".slider-thumb.left");
    this.thumbRight = document.querySelector(".slider-thumb.right");
  }

  initFoodItems() {
    const storedItems = localStorage.getItem(this.FOOD_ITEMS_STORAGE_KEY);
    if (storedItems) {
      this.displayedFoodItems = JSON.parse(storedItems);
    } else {
      this.displayedFoodItems = JSON.parse(JSON.stringify(window.foodItems));
      localStorage.setItem(this.FOOD_ITEMS_STORAGE_KEY, JSON.stringify(this.displayedFoodItems));
    }
  }

  populateCategoryDropdown() {
    const categories = ["All", ...new Set(this.displayedFoodItems.map(item => item.category))];
    const categoryList = this.categoryDropdown.querySelector(".dropdown-options");

    categoryList.innerHTML = "";
    categories.forEach(category => {
      const li = document.createElement("li");
      li.textContent = category;
      categoryList.appendChild(li);
    });

    categoryList.addEventListener("click", (e) => {
      if (e.target.tagName === "LI") {
        this.selectedCategory = e.target.textContent;
        this.applyFilters();
      }
    });
  }

  setupListeners() {
    this.sortDropdown.addEventListener("click", (e) => {
      if (e.target.tagName === "LI") {
        this.selectedSort = e.target.getAttribute("data-value") || "default";
        this.applyFilters();
      }
    });

    this.vegetarianToggle.addEventListener("change", () => this.applyFilters());
  }

  setupPriceRangeSlider() {
    if (this.displayedFoodItems.length === 0) return;

    const prices = this.displayedFoodItems.map(item => item.price);
    const minPrice = Math.min(...prices);
    const maxPrice = Math.max(...prices);

    this.priceRangeMin.min = minPrice;
    this.priceRangeMax.min = minPrice;
    this.priceRangeMin.max = maxPrice;
    this.priceRangeMax.max = maxPrice;
    this.priceRangeMin.value = minPrice;
    this.priceRangeMax.value = maxPrice;

    this.minPriceLabel.textContent = `$${minPrice}`;
    this.maxPriceLabel.textContent = `$${maxPrice}`;
    this.updateSliderRangeUI();

    const minGap = 5;
    this.priceRangeMin.addEventListener("input", () => {
      if (parseInt(this.priceRangeMax.value) - parseInt(this.priceRangeMin.value) < minGap) {
        this.priceRangeMin.value = parseInt(this.priceRangeMax.value) - minGap;
      }
      this.minPriceLabel.textContent = `$${this.priceRangeMin.value}`;
      this.updateSliderRangeUI();
      this.applyFilters();
    });

    this.priceRangeMax.addEventListener("input", () => {
      if (parseInt(this.priceRangeMax.value) - parseInt(this.priceRangeMin.value) < minGap) {
        this.priceRangeMax.value = parseInt(this.priceRangeMin.value) + minGap;
      }
      this.maxPriceLabel.textContent = `$${this.priceRangeMax.value}`;
      this.updateSliderRangeUI();
      this.applyFilters();
    });
  }

  updateSliderRangeUI() {
    const minVal = parseInt(this.priceRangeMin.value);
    const maxVal = parseInt(this.priceRangeMax.value);
    const range = this.priceRangeMax.max - this.priceRangeMin.min;

    const minPercent = ((minVal - this.priceRangeMin.min) / range) * 100;
    const maxPercent = ((maxVal - this.priceRangeMin.min) / range) * 100;

    this.sliderRange.style.left = minPercent + "%";
    this.sliderRange.style.right = (100 - maxPercent) + "%";
    this.thumbLeft.style.left = minPercent + "%";
    this.thumbRight.style.left = maxPercent + "%";
  }

  applyFilters() {
    const isVegetarian = this.vegetarianToggle.checked;
    const minPrice = parseInt(this.priceRangeMin.value);
    const maxPrice = parseInt(this.priceRangeMax.value);

    let filtered = this.displayedFoodItems.filter(item =>
      (this.selectedCategory === "All" || item.category === this.selectedCategory) &&
      (!isVegetarian || item.vegetarian) &&
      item.price >= minPrice &&
      item.price <= maxPrice
    );

    if (this.selectedSort === "asc") filtered.sort((a, b) => a.price - b.price);
    else if (this.selectedSort === "desc") filtered.sort((a, b) => b.price - a.price);

    this.renderGrid(filtered);
  }

  renderGrid(items) {
    this.grid.innerHTML = "";

    items.forEach(item => {
      const card = document.createElement("div");
      card.className = "food-card";
      card.innerHTML = `
        <img src="${item.img}" alt="${item.name}" />
        <h3>${item.name}</h3>
        <p>${item.category}</p>
        <strong>$${item.price.toFixed(2)}</strong>
      `;
      this.grid.appendChild(card);
    });
  }
}
