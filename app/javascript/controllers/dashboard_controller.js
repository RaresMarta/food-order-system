import { Controller } from "@hotwired/stimulus"
import "../constants"

export default class extends Controller {
  connect() {
    console.log("Dashboard Stimulus controller connected");

    this.foodForm = document.getElementById('food-form');
    this.foodNameInput = document.getElementById('food-name');
    this.foodCategoryInput = document.getElementById('food-category');
    this.foodPriceInput = document.getElementById('food-price');
    this.foodVegetarianInput = document.getElementById('food-vegetarian');
    this.foodImageInput = document.getElementById('food-image');
    this.clearFormButton = document.getElementById('clear-form');
    this.resetItemsButton = document.getElementById('reset-to-baseline');
    this.foodTableBody = document.getElementById('food-table-body');

    this.FOOD_ITEMS_STORAGE_KEY = 'eurekaCaffeMenuItems';
    this.foodItems = [];
    this.editingItemId = null;

    this.initDashboard();
  }

  initDashboard() {
    const storedItems = localStorage.getItem(this.FOOD_ITEMS_STORAGE_KEY);

    if (storedItems) {
      this.foodItems = JSON.parse(storedItems);
    } else {
      this.resetToBaseline();
    }

    this.renderFoodTable();
    this.setupEventListeners();
  }

  resetToBaseline() {
    if (window.foodItems && Array.isArray(window.foodItems)) {
      this.foodItems = JSON.parse(JSON.stringify(window.foodItems));
    } else {
      this.foodItems = [];
    }
    this.saveFoodItems();
  }

  saveFoodItems() {
    localStorage.setItem(this.FOOD_ITEMS_STORAGE_KEY, JSON.stringify(this.foodItems));
  }

  renderFoodTable() {
    this.foodTableBody.innerHTML = '';
    if (this.foodItems.length === 0) {
      const emptyRow = document.createElement('tr');
      emptyRow.innerHTML = `
        <td colspan="6" class="empty-state">
          <p>No food items found.</p>
          <button class="btn btn-primary" id="add-default-items">Add Default Items</button>
        </td>
      `;
      this.foodTableBody.appendChild(emptyRow);
      document.getElementById('add-default-items').addEventListener('click', this.resetToBaseline.bind(this));
      return;
    }

    this.foodItems.forEach(item => {
      const row = document.createElement('tr');
      row.innerHTML = `
        <td>${item.id}</td>
        <td>${item.name}</td>
        <td>${item.category}</td>
        <td>$${item.price.toFixed(2)}</td>
        <td>${item.vegetarian ? 'Yes' : 'No'}</td>
        <td class="action-buttons">
          <button class="btn btn-edit edit-item" data-id="${item.id}">Edit</button>
          <button class="btn btn-danger delete-item" data-id="${item.id}">Delete</button>
        </td>
      `;
      this.foodTableBody.appendChild(row);
    });

    document.querySelectorAll('.edit-item').forEach(button => {
      button.addEventListener('click', this.handleEditItem.bind(this));
    });

    document.querySelectorAll('.delete-item').forEach(button => {
      button.addEventListener('click', this.handleDeleteItem.bind(this));
    });
  }

  setupEventListeners() {
    this.foodForm.addEventListener('submit', this.handleFormSubmit.bind(this));
    this.clearFormButton.addEventListener('click', this.clearForm.bind(this));
    this.resetItemsButton.addEventListener('click', () => {
      if (confirm('Are you sure you want to reset all items to defaults? This will remove any custom items you\'ve added.')) {
        this.resetToBaseline();
        this.renderFoodTable();
      }
    });
  }

  handleFormSubmit(e) {
    e.preventDefault();
    const name = this.foodNameInput.value.trim();
    const category = this.foodCategoryInput.value.trim();
    const price = parseFloat(this.foodPriceInput.value);
    const vegetarian = this.foodVegetarianInput.checked;
    const imageUrl = this.foodImageInput.value.trim();

    if (!name || !category || isNaN(price) || !imageUrl) {
      alert('Please fill in all required fields');
      return;
    }

    if (this.editingItemId) {
      const index = this.foodItems.findIndex(item => item.id === this.editingItemId);
      if (index !== -1) {
        this.foodItems[index] = {
          ...this.foodItems[index],
          name,
          category,
          price,
          vegetarian,
          img: imageUrl
        };
      }
      this.editingItemId = null;
    } else {
      const newId = this.foodItems.length > 0
        ? Math.max(...this.foodItems.map(item => item.id)) + 1
        : 1;

      const newItem = {
        id: newId,
        name,
        category,
        price,
        vegetarian,
        img: imageUrl
      };

      this.foodItems.push(newItem);
    }

    this.saveFoodItems();
    this.renderFoodTable();
    this.clearForm();
  }

  handleEditItem(e) {
    const itemId = parseInt(e.target.dataset.id);
    const item = this.foodItems.find(item => item.id === itemId);

    if (item) {
      this.editingItemId = itemId;

      this.foodNameInput.value = item.name;
      this.foodCategoryInput.value = item.category;
      this.foodPriceInput.value = item.price;
      this.foodVegetarianInput.checked = item.vegetarian;
      this.foodImageInput.value = item.img;

      const submitButton = this.foodForm.querySelector('button[type="submit"]');
      submitButton.textContent = 'Update Item';
      this.foodForm.scrollIntoView({ behavior: 'smooth' });
    }
  }

  handleDeleteItem(e) {
    const itemId = parseInt(e.target.dataset.id);

    if (confirm('Are you sure you want to delete this item?')) {
      this.foodItems = this.foodItems.filter(item => item.id !== itemId);
      this.saveFoodItems();
      this.renderFoodTable();
    }
  }

  clearForm() {
    this.foodForm.reset();
    this.editingItemId = null;
    const submitButton = this.foodForm.querySelector('button[type="submit"]');
    submitButton.textContent = 'Add Item';
  }
}
