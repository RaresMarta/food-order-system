import { Controller } from "@hotwired/stimulus"

export default class DashboardController extends Controller {
  static targets = [
    "form", "name", "category", "price", "vegetarian", "image",
    "clearButton", "resetButton", "tableBody", "submitButton"
  ]

  connect() {
    console.log("✅ Stimulus dashboard controller connected");
    this.foodItems = [];
    this.editingItemId = null;
    this.initDashboard();
  }

  async initDashboard() {
    try {
      let resp = await fetch("/food_items", { credentials: "same-origin" });
      if (!resp.ok) throw new Error(await resp.text());
      this.foodItems = await resp.json();
    } catch (e) {
      console.error("Couldn't load food items:", e);
      this.foodItems = [];
    }
    this.renderFoodTable();
  }

  resetToBaseline() {
    if (window.foodItems && Array.isArray(window.foodItems)) {
      this.foodItems = JSON.parse(JSON.stringify(window.foodItems));
    } else {
      this.foodItems = [];
    }
    this.saveFoodItems();
    this.renderFoodTable();
  }

  saveFoodItems() {
    localStorage.setItem(this.FOOD_ITEMS_STORAGE_KEY, JSON.stringify(this.foodItems));
  }

  renderFoodTable() {
    this.tableBodyTarget.innerHTML = '';

    if (this.foodItems.length === 0) {
      const emptyRow = document.createElement('tr');
      emptyRow.innerHTML = `
        <td colspan="7" class="empty-state">
          <p>No food items found.</p>
          <button class="btn btn-primary" data-action="click->dashboard#resetToBaseline">Add Default Items</button>
        </td>
      `;
      this.tableBodyTarget.appendChild(emptyRow);
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
        <td>
          ${item.image_url ? `<img src="${item.image_url}" alt="${item.name}" style="height:50px"/>` : ''}
        </td>
        <td class="action-buttons">
          <button class="btn btn-edit" data-id="${item.id}" data-action="click->dashboard#handleEditItem">Edit</button>
          <button class="btn btn-danger" data-id="${item.id}" data-action="click->dashboard#handleDeleteItem">Delete</button>
        </td>
      `;
      this.tableBodyTarget.appendChild(row);
    });
  }

  async handleFormSubmit(e) {
    e.preventDefault();

    const formData = new FormData();
    formData.append("food_item[name]", this.nameTarget.value);
    formData.append("food_item[category]", this.categoryTarget.value);
    formData.append("food_item[price]", this.priceTarget.value);
    formData.append("food_item[vegetarian]", this.vegetarianTarget.checked);
    if (this.imageTarget.files[0]) {
      formData.append("food_item[image]", this.imageTarget.files[0]);
    }

    let url = "/food_items";
    let method = "POST";
    if (this.editingItemId) {
      url = `/food_items/${this.editingItemId}`;
      method = "PATCH";
    }

    try {
      const resp = await fetch(url, {
        method,
        body: formData,
        credentials: "same-origin"
      });

      if (!resp.ok) throw await resp.json();
      const item = await resp.json();

      if (this.editingItemId) {
        this.foodItems = this.foodItems.map(i => i.id === item.id ? item : i);
      } else {
        this.foodItems.push(item);
      }

      this.editingItemId = null;
      this.clearForm();
      this.renderFoodTable();
    } catch (err) {
      console.error("Save failed:", err);
      alert("Could not save food item: " + (err.errors || err));
    }
  }

  handleEditItem(e) {
    const id = e.target.dataset.id;
    const item = this.foodItems.find(item => item.id === id);
    if (!item) return;

    this.editingItemId = id;
    this.nameTarget.value = item.name;
    this.categoryTarget.value = item.category;
    this.priceTarget.value = item.price;
    this.vegetarianTarget.checked = item.vegetarian;
    this.submitButtonTarget.textContent = 'Update Item';
    this.formTarget.scrollIntoView({ behavior: 'smooth' });
  }

  async handleDeleteItem(e) {
    const id = e.target.dataset.id;
    if (!confirm("Are you sure?")) return;

    try {
      let resp = await fetch(`/food_items/${id}`, {
        method: "DELETE",
        credentials: "same-origin"
      });
      if (!resp.ok) throw await resp.text();

      this.foodItems = this.foodItems.filter(i => i.id != id);
      this.renderFoodTable();
    } catch (e) {
      console.error("Delete failed:", e);
      alert("Could not delete item");
    }
  }

  clearForm() {
    this.formTarget.reset();
    this.editingItemId = null;
    this.submitButtonTarget.textContent = 'Add Item';
  }
}
