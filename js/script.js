const grid = document.getElementById("food-grid");
const categoryDropdown = document.getElementById("category-dropdown");
const sortDropdown = document.getElementById("sort-dropdown");
const vegetarianToggle = document.getElementById("vegetarian-toggle");
const priceRangeMin = document.getElementById('price-range-min');
const priceRangeMax = document.getElementById('price-range-max');
const minPriceLabel = document.querySelector('.min-price');
const maxPriceLabel = document.querySelector('.max-price');
const sliderRange = document.querySelector('.slider-range');
const thumbLeft = document.querySelector('.slider-thumb.left');
const thumbRight = document.querySelector('.slider-thumb.right');

const FOOD_ITEMS_STORAGE_KEY = 'eurekaCaffeMenuItems';
let selectedCategory = "All";
let selectedSort = "default";

/* Get food items from local storage or use default ones */
let displayedFoodItems = [];
const storedItems = localStorage.getItem(FOOD_ITEMS_STORAGE_KEY);
if (storedItems) {
  displayedFoodItems = JSON.parse(storedItems);
} else {
  displayedFoodItems = JSON.parse(JSON.stringify(window.foodItems));
  localStorage.setItem(FOOD_ITEMS_STORAGE_KEY, JSON.stringify(displayedFoodItems));
}

/* Category Dropdown */
const categories = ["All", ...new Set(displayedFoodItems.map(item => item.category))];
const categoryList = categoryDropdown.querySelector(".dropdown-options");
categoryList.innerHTML = '';
categories.forEach(category => {
  const listItem = document.createElement("li");
  listItem.textContent = category;
  categoryList.appendChild(listItem);
});

categoryList.addEventListener("click", (e) => {
  if (e.target.tagName === "LI") {
    selectedCategory = e.target.textContent;
    applyFilters();
  }
});

/* Sort Dropdown */
sortDropdown.addEventListener("click", (e) => {
  if (e.target.tagName === "LI") {
    selectedSort = e.target.getAttribute("data-value") || "default";
    applyFilters();
  }
});

// Initial render
renderGrid(displayedFoodItems);

// Set up price range slider
if (displayedFoodItems.length > 0) {
  const prices = displayedFoodItems.map(item => item.price);
  const minPrice = Math.min(...prices);
  const maxPrice = Math.max(...prices);

  priceRangeMin.min = minPrice;
  priceRangeMax.min = minPrice;
  priceRangeMin.max = maxPrice;
  priceRangeMax.max = maxPrice;
  priceRangeMin.value = minPrice;
  priceRangeMax.value = maxPrice;

  minPriceLabel.textContent = `$${minPrice}`;
  maxPriceLabel.textContent = `$${maxPrice}`;

  updateSliderRangeUI();

  const minGap = 5;
  priceRangeMin.addEventListener('input', function() {
    if (parseInt(priceRangeMax.value) - parseInt(priceRangeMin.value) < minGap) {
      priceRangeMin.value = parseInt(priceRangeMax.value) - minGap;
    }
    minPriceLabel.textContent = `$${priceRangeMin.value}`;
    updateSliderRangeUI();
    applyFilters();
  });

  priceRangeMax.addEventListener('input', function() {
    if (parseInt(priceRangeMax.value) - parseInt(priceRangeMin.value) < minGap) {
      priceRangeMax.value = parseInt(priceRangeMin.value) + minGap;
    }
    maxPriceLabel.textContent = `$${priceRangeMax.value}`;
    updateSliderRangeUI();
    applyFilters();
  });
}

function updateSliderRangeUI() {
  const minVal = parseInt(priceRangeMin.value);
  const maxVal = parseInt(priceRangeMax.value);
  const minPercent = ((minVal - priceRangeMin.min) / (priceRangeMax.max - priceRangeMin.min)) * 100;
  const maxPercent = ((maxVal - priceRangeMin.min) / (priceRangeMax.max - priceRangeMin.min)) * 100;

  sliderRange.style.left = minPercent + '%';
  sliderRange.style.right = (100 - maxPercent) + '%';
  thumbLeft.style.left = minPercent + '%';
  thumbRight.style.left = maxPercent + '%';
}

vegetarianToggle.addEventListener('change', applyFilters);

function applyFilters() {
  const isVegetarian = vegetarianToggle.checked;
  const minPrice = parseInt(priceRangeMin.value);
  const maxPrice = parseInt(priceRangeMax.value);

  let filtered = displayedFoodItems.filter(item =>
    (selectedCategory === "All" || item.category === selectedCategory) &&
    (!isVegetarian || item.vegetarian) &&
    item.price >= minPrice &&
    item.price <= maxPrice
  );

  if (selectedSort === "asc") filtered.sort((a, b) => a.price - b.price);
  else if (selectedSort === "desc") filtered.sort((a, b) => b.price - a.price);

  renderGrid(filtered);
}

function renderGrid(items) {
  grid.innerHTML = "";

  items.forEach(item => {
    const card = document.createElement("div");
    card.className = "food-card";
    card.innerHTML = `
      <img src="${item.img}" alt="${item.name}" />
      <h3>${item.name}</h3>
      <p>${item.category}</p>
      <strong>$${item.price.toFixed(2)}</strong>
    `;

    grid.appendChild(card);
  });
}
