// DOM Elements
const foodForm = document.getElementById('food-form');
const foodNameInput = document.getElementById('food-name');
const foodCategoryInput = document.getElementById('food-category');
const foodPriceInput = document.getElementById('food-price');
const foodVegetarianInput = document.getElementById('food-vegetarian');
const foodImageInput = document.getElementById('food-image');
const clearFormButton = document.getElementById('clear-form');
const foodTableBody = document.getElementById('food-table-body');

// Local Storage Key
const FOOD_ITEMS_STORAGE_KEY = 'eurekaCaffeMenuItems';

// State variables
let foodItems = [];
let editingItemId = null;

// Initialize the dashboard
function initDashboard() {
  // Load items from local storage or use the global window.foodItems as baseline
  const storedItems = localStorage.getItem(FOOD_ITEMS_STORAGE_KEY);
  if (storedItems) {
    foodItems = JSON.parse(storedItems);
  } else {
    resetToBaseline();
  }
  
  renderFoodTable();
  setupEventListeners();
}

// Reset to baseline items from constants.js
function resetToBaseline() {
  // Check if window.foodItems exists and is an array
  if (window.foodItems && Array.isArray(window.foodItems)) {
    foodItems = JSON.parse(JSON.stringify(window.foodItems));
  } else {
    console.error('Error: window.foodItems is not available. Make sure constants.js is loaded properly.');
    // Fallback to empty array or default items if needed
    foodItems = [];
  }
  
  // Save to local storage to ensure consistency with the main page
  saveFoodItems();
}

// Save food items to local storage
function saveFoodItems() {
  localStorage.setItem(FOOD_ITEMS_STORAGE_KEY, JSON.stringify(foodItems));
}

// Render the food items table
function renderFoodTable() {
  foodTableBody.innerHTML = '';
  
  if (foodItems.length === 0) {
    const emptyRow = document.createElement('tr');
    emptyRow.innerHTML = `
      <td colspan="6" class="empty-state">
        <p>No food items found.</p>
        <button class="btn btn-primary" id="add-default-items">Add Default Items</button>
      </td>
    `;
    foodTableBody.appendChild(emptyRow);
    
    // Add event listener to the "Add Default Items" button
    document.getElementById('add-default-items').addEventListener('click', resetToBaseline);
    
    return;
  }
  
  foodItems.forEach(item => {
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
    foodTableBody.appendChild(row);
  });
  
  // Add event listeners to the action buttons
  document.querySelectorAll('.edit-item').forEach(button => {
    button.addEventListener('click', handleEditItem);
  });
  
  document.querySelectorAll('.delete-item').forEach(button => {
    button.addEventListener('click', handleDeleteItem);
  });
}

// Set up event listeners
function setupEventListeners() {
  foodForm.addEventListener('submit', handleFormSubmit);
  clearFormButton.addEventListener('click', clearForm);
  
  // Add reset button to the form buttons
  const formButtons = document.querySelector('.form-buttons');
  const resetButton = document.createElement('button');
  resetButton.type = 'button';
  resetButton.className = 'btn btn-reset';
  resetButton.id = 'reset-to-baseline';
  resetButton.textContent = 'Reset to Default Items';
  formButtons.appendChild(resetButton);
  
  // Add event listener to the reset button
  document.getElementById('reset-to-baseline').addEventListener('click', function() {
    if (confirm('Are you sure you want to reset all items to defaults? This will remove any custom items you\'ve added.')) {
      resetToBaseline();
      renderFoodTable();
    }
  });
}

// Handle form submission
function handleFormSubmit(e) {
  e.preventDefault();
  
  const name = foodNameInput.value.trim();
  const category = foodCategoryInput.value.trim();
  const price = parseFloat(foodPriceInput.value);
  const vegetarian = foodVegetarianInput.checked;
  const imageUrl = foodImageInput.value.trim();
  
  if (!name || !category || isNaN(price) || !imageUrl) {
    alert('Please fill in all required fields');
    return;
  }
  
  if (editingItemId) {
    // Update existing item
    const index = foodItems.findIndex(item => item.id === editingItemId);
    if (index !== -1) {
      foodItems[index] = {
        ...foodItems[index],
        name,
        category,
        price,
        vegetarian,
        img: imageUrl
      };
    }
    editingItemId = null;
  } else {
    // Add new item
    const newId = foodItems.length > 0 
      ? Math.max(...foodItems.map(item => item.id)) + 1 
      : 1;
    
    const newItem = {
      id: newId,
      name,
      category,
      price,
      vegetarian,
      img: imageUrl
    };
    
    foodItems.push(newItem);
  }
  
  saveFoodItems();
  renderFoodTable();
  clearForm();
}

// Handle edit item button click
function handleEditItem(e) {
  const itemId = parseInt(e.target.dataset.id);
  const item = foodItems.find(item => item.id === itemId);
  
  if (item) {
    editingItemId = itemId;
    
    foodNameInput.value = item.name;
    foodCategoryInput.value = item.category;
    foodPriceInput.value = item.price;
    foodVegetarianInput.checked = item.vegetarian;
    foodImageInput.value = item.img;
    
    // Change submit button text
    const submitButton = foodForm.querySelector('button[type="submit"]');
    submitButton.textContent = 'Update Item';
    
    // Scroll to form
    foodForm.scrollIntoView({ behavior: 'smooth' });
  }
}

// Handle delete item button click
function handleDeleteItem(e) {
  const itemId = parseInt(e.target.dataset.id);
  
  if (confirm('Are you sure you want to delete this item?')) {
    foodItems = foodItems.filter(item => item.id !== itemId);
    saveFoodItems();
    renderFoodTable();
  }
}

// Clear the form
function clearForm() {
  foodForm.reset();
  editingItemId = null;
  
  // Reset submit button text
  const submitButton = foodForm.querySelector('button[type="submit"]');
  submitButton.textContent = 'Add Item';
}

// Initialize the dashboard when the page loads
document.addEventListener('DOMContentLoaded', initDashboard); 
